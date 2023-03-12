# SUI Objects & Ownerships & Sharing & Params

## Ownership in Object

- Owned by address
- Owned by objects

```sh
# owned by address
transfer::transfer(transcriptObject, tx_context::sender(ctx)) 
# where tx_context::sender(ctx) is the recipient
```

## Sharing of Objects

- Shared Immutable Objects
- Shared Mutable objects

```sh
# Shared Immutable Objects
transfer::freeze_object(obj);
# Shared Mutable Objects
transfer::share_object(obj);
```

## Parameters Passing

- passing by value
- passing by reference
- passing by mutable reference

```sh
# Passing by Reference
# --------------------
# You are allowed to retrieve the score but cannot modify it
public fun view_score(transcriptObject: &TranscriptObject): u8{
    transcriptObject.literature
}

# Passing as Mutable Object
# -------------------------
# You are allowed to view and edit the score but not allowed to delete it
public entry fun update_score(transcriptObject: &mut TranscriptObject, score: u8){
    transcriptObject.literature = score
}

# Passing by Value
# ----------------
# You are allowed to do anything with the score, including view, edit, delete the entire transcript itself.
public entry fun delete_transcript(transcriptObject: TranscriptObject){
    let TranscriptObject {id, history: _, math: _, literature: _ } = transcriptObject;
    object::delete(id);
}
```

## Object Wrapping

```sh
struct WrappableTranscript has store {
    history: u8,
    math: u8,
    literature: u8,
}

struct Folder has key {
    id: UID,
    transcript: WrappableTranscript,
}
```

## Deployment

```sh
sui move build

# -------


UPDATING GIT DEPENDENCY https://github.com/MystenLabs/sui.git
UPDATING GIT DEPENDENCY https://github.com/MystenLabs/sui.git
UPDATING GIT DEPENDENCY https://github.com/MystenLabs/sui.git
UPDATING GIT DEPENDENCY https://github.com/MystenLabs/sui.git
INCLUDING DEPENDENCY Sui
INCLUDING DEPENDENCY MoveStdlib
BUILDING object_and_ownership
```

```sh
sui client publish --gas-budget 30000

# -------

----- Certificate ----
Transaction Hash: TransactionDigest(FXWU4YY5Me7iRJ7KMVVaWqeLRftUs7RMspE4LsAV1fqS)
Transaction Signature: [Signature(AQ==@Lukd2iI08QgOFHIFySHmEj1MlIS2pLp/PFNJo5NkHakqiec4tAwos1oVd00i2oGknah92amYLezpTbFpX1AxNg==@A5OvyYAut3Zpy7T3S/LZL5vdfgR0+ovq4+QOUO0fxw+c)]
Signed Authorities Bitmap: RoaringBitmap<[1, 2, 3]>
Transaction Kind : Publish
Sender: 0x15d2b782e1ab6130bb312c477439126c06ffb594
Gas Payment: Object ID: 0x07e8ca322f770dcb0b3c9a3f3809d01be23798d5, version: 0xa1bf, digest: o#5VIGL7QkOaMI5mlOuTTN+HiOy6fz5m1cky2ABm2zM7s=
Gas Owner: 0x15d2b782e1ab6130bb312c477439126c06ffb594
Gas Price: 1
Gas Budget: 30000
----- Transaction Effects ----
Status : Success
Created Objects:
  - ID: 0x4e9ec09ec10bff6652a9fd68c3e5fdd69f98244f , Owner: Immutable
  - ID: 0x8136cd046a50cffaa44c073b76d2e976558de3b4 , Owner: Account Address ( 0x15d2b782e1ab6130bb312c477439126c06ffb594 )
Mutated Objects:
  - ID: 0x07e8ca322f770dcb0b3c9a3f3809d01be23798d5 , Owner: Account Address ( 0x15d2b782e1ab6130bb312c477439126c06ffb594 )

```
