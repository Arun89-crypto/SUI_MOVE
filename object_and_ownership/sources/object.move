module object_and_ownership::object_and_ownership {

    // imports
    use sui::object::{Self,ID,UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::event;

    // errors
    const ENotIntendedAddress:u64 = 1;

    struct WrappableTranscript has key, store {
        id: UID,
        history: u8,
        math: u8,
        literature: u8
    }

    struct Folder has key {
        id: UID,
        transcript: WrappableTranscript,
        intended_address: address
    }

    // teacher cap is a privileged user to edit the object
    struct TeacherCap has key {
        id: UID
    }

    // events
    /// Event marking when a transcript has been requested
    struct TranscriptRequestEvent has copy, drop {
        // The Object ID of the transcript wrapper
        wrapper_id: ID,
        // The requester of the transcript
        requester: address,
        // The intended address of the transcript
        intended_address: address,
    }

    // Initializer function : will run whenever we publish the module
    // In this case it is giving the TeacherCap right to the address which is deploying the contract
    fun init(ctx: &mut TxContext) {
        transfer::transfer(TeacherCap {
            id: object::new(ctx)
        }, tx_context::sender(ctx))
    }

    // function to give TeacherCap privileges to another address
    public entry fun add_additional_teacher(_: &TeacherCap, new_teacher_address: address, ctx: &mut TxContext){
        transfer::transfer(
            TeacherCap {
                id: object::new(ctx)
            },
        new_teacher_address
        )
    }

    public entry fun request_transcript(transcript: WrappableTranscript, intended_address: address, ctx: &mut TxContext) {
        let folderObject = Folder {
            id: object::new(ctx),
            transcript,
            intended_address
        };
        event::emit(TranscriptRequestEvent {
            wrapper_id: object::uid_to_inner(&folderObject.id),
            requester: tx_context::sender(ctx),
            intended_address,
        });
        transfer::transfer(folderObject, intended_address);
    }


    // _: &TeacherCap : this will pre read the txn object and give the privileges to the initiator
    public entry fun create_wrappable_transcript_object(_: &TeacherCap, history: u8, math: u8, literature: u8, ctx: &mut TxContext) {
        let wrappableTranscript = WrappableTranscript {
            id: object::new(ctx),
            history,
            math,
            literature,
        };
        transfer::transfer(wrappableTranscript, tx_context::sender(ctx))
    }

    // You are allowed to retrieve the score but cannot modify it
    public fun view_score(transcriptObject: &WrappableTranscript): u8{
        transcriptObject.literature
    }

    // You are allowed to view and edit the score but not allowed to delete it
    public entry fun update_score(_: &TeacherCap, transcriptObject: &mut WrappableTranscript, score: u8){
        transcriptObject.literature = score
    }

    // You are allowed to do anything with the score, including view, edit, delete the entire transcript itself.
    public entry fun delete_transcript(_: &TeacherCap, transcriptObject: WrappableTranscript){
        let WrappableTranscript {id, history: _, math: _, literature: _ } = transcriptObject;
        object::delete(id);
    }

    public entry fun unpack_wrapped_transcript(folder: Folder, ctx: &mut TxContext) {
        assert!(folder.intended_address == tx_context::sender(ctx), ENotIntendedAddress);

        let Folder {
            id,
            transcript,
            intended_address:_,
        } = folder;

        transfer::transfer(transcript, tx_context::sender(ctx));
        object::delete(id);
    }

}