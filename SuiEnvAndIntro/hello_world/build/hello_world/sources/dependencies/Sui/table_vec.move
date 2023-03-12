// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

/// A basic scalable vector library implemented using `Table`.
module sui::table_vec {
    use sui::table::{Self, Table};
    use sui::tx_context::TxContext;

    struct TableVec<phantom Element: store> has store {
        /// The contents of the table vector.
        contents: Table<u64, Element>,
    }

    const EINDEX_OUT_OF_BOUND: u64 = 0;
    const ETABLE_NONEMPTY: u64 = 1;

    /// Create an empty TableVec.
    public fun empty<Element: store>(ctx: &mut TxContext): TableVec<Element> {
        TableVec {
            contents: table::new(ctx)
        }
    }

    /// Return a TableVec of size one containing element `e`.
    public fun singleton<Element: store>(e: Element, ctx: &mut TxContext): TableVec<Element> {
        let t = empty(ctx);
        push_back(&mut t, e);
        t
    }

    /// Return the length of the TableVec.
    public fun length<Element: store>(t: &TableVec<Element>): u64 {
        table::length(&t.contents)
    }

    /// Return if the TableVec is empty or not.
    public fun is_empty<Element: store>(t: &TableVec<Element>): bool {
        length(t) == 0
    }

    /// Acquire an immutable reference to the `i`th element of the TableVec `t`.
    /// Aborts if `i` is out of bounds.
    public fun borrow<Element: store>(t: &TableVec<Element>, i: u64): &Element {
        assert!(length(t) > i, EINDEX_OUT_OF_BOUND);
        table::borrow(&t.contents, i)
    }

    /// Add element `e` to the end of the TableVec `t`.
    public fun push_back<Element: store>(t: &mut TableVec<Element>, e: Element) {
        let key = length(t);
        table::add(&mut t.contents, key, e);
    }

    /// Return a mutable reference to the `i`th element in the TableVec `t`.
    /// Aborts if `i` is out of bounds.
    public fun borrow_mut<Element: store>(t: &mut TableVec<Element>, i: u64): &mut Element {
        assert!(length(t) > i, EINDEX_OUT_OF_BOUND);
        table::borrow_mut(&mut t.contents, i)
    }

    /// Pop an element from the end of TableVec `t`.
    /// Aborts if `t` is empty.
    public fun pop_back<Element: store>(t: &mut TableVec<Element>): Element {
        let length = length(t);
        assert!(length > 0, EINDEX_OUT_OF_BOUND);
        table::remove(&mut t.contents, length - 1)
    }

    /// Destroy the TableVec `t`.
    /// Aborts if `t` is not empty.
    public fun destroy_empty<Element: store>(t: TableVec<Element>) {
        assert!(length(&t) == 0, ETABLE_NONEMPTY);
        let TableVec { contents } = t;
        table::destroy_empty(contents);
    }

}
