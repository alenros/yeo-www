+++
date = "2017-01-04T00:01:19-08:00"
title = "mongodb sync index"
draft = true

+++

When operating MongoDB at scale, I found mysef have to add/remove
replica a lot. One thing that always bug me is the index. I used Mongoid
as my ODM, so once the index is defined, creating it is easily with:

```
rake db:mongoid:create_indexes
```

However, given my  experience, lots of time the index wasn't created properly.
It's maybe because old version of gem that I used. But that's in the
point of this post.

In this article, I want to show you how we can manually sync index from
primary. When we add a new replica to replica set, the single index is
created automatically but the compound index weren't.

The mothod that I used is very simple. It go over the source database,
read the index, and attempt to re-create them in the secondary. Here is
the procedure.

## Remove the secondary from replicaset

This is necessary because we cannot write to a secondary.

## Create the index

## Add the node back to replica set

Finally now the indexes are in-sync with master and any new index will
be replicated to secondary as well
