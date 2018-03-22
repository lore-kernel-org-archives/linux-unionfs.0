Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJfpegtgJWinj=81rdm9+8VjTo8PDnNPU8d587dvaZj6X1nvQA@mail.gmail.com>
References: <1520767374-19374-1-git-send-email-amir73il@gmail.com>
 <1520767374-19374-4-git-send-email-amir73il@gmail.com> <CAJfpegtgJWinj=81rdm9+8VjTo8PDnNPU8d587dvaZj6X1nvQA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 22 Mar 2018 13:55:29 +0200
Message-ID: <CAOQ4uxhZEneTh3+Fa9h4resHge8ODQwD8ti7Hqj7WE5QF5J0+w@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ovl: lookup in inode cache first when decoding
 lower file handle
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 22, 2018 at 12:41 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Sun, Mar 11, 2018 at 12:22 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> When decoding a lower file handle, we need to check if lower file was
>> copied up and indexed and if it has a whiteout index, we need to check
>> if this is an unlinked but open non-dir before returning -ESTALE.
>>
>> To find out if this is an unlinked but open non-dir we need to lookup
>> an overlay inode in inode cache by lower inode and that requires decoding
>> the lower file handle before looking in inode cache.
>>
>> Before this change, if the lower inode turned out to be a directory, we
>> may have paid an expensive cost to reconnect that lower directory for
>> nothing.
>>
>> After this change, we start by decoding a disconnected lower dentry and
>> using the lower inode for looking up an overlay inode in inode cache.
>> If we find overlay inode and dentry in cache, we avoid the index lookup
>> overhead. If we don't find an overlay inode and dentry in cache, then we
>> only need to decode a connected lower dentry in case the lower dentry is
>> a non-indexed directory.
>>
>> The xfstests group overlay/exportfs tests decoding overlayfs file
>> handles after drop_caches with different states of the file at encode
>> and decode time. Overall the tests in the group call ovl_lower_fh_to_d()
>> 89 times to decode a lower file handle.
>>
>> Before this change, the tests called ovl_get_index_fh() 75 times and
>> reconnect_one() 61 times.
>> After this change, the tests call ovl_get_index_fh() 70 times and
>> reconnect_one() 59 times. The 2 cases where reconnect_one() was avoided
>> are cases where a non-upper directory file handle was encoded, then the
>> directory removed and then file handle was decoded.
>>
>> To demonstrate the affect on decoding file handles with hot inode/dentry
>> cache, the drop_caches call in the tests was disabled. Without
>> drop_caches, there are no reconnect_one() calls at all before or after
>> the change. Before the change, there are 75 calls to ovl_get_index_fh(),
>> exactly as the case with drop_caches. After the change, there are only
>> 10 calls to ovl_get_index_fh().
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/overlayfs/export.c | 58 +++++++++++++++++++++++++++++----------------------
>>  1 file changed, 33 insertions(+), 25 deletions(-)
>>
>> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
>> index 15411350a7a1..a908da8b63c1 100644
>> --- a/fs/overlayfs/export.c
>> +++ b/fs/overlayfs/export.c
>> @@ -703,25 +703,39 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
>>         struct ovl_path *stack = &origin;
>>         struct dentry *dentry = NULL;
>>         struct dentry *index = NULL;
>> -       struct inode *inode = NULL;
>> -       bool is_deleted = false;
>> +       struct inode *inode;
>>         int err;
>>
>> -       /* First lookup indexed upper by fh */
>> +       /* First lookup overlay inode in inode cache by origin fh */
>> +       err = ovl_check_origin_fh(ofs, fh, false, NULL, &stack);
>> +       if (err)
>> +               return ERR_PTR(err);
>> +
>> +       if (d_is_dir(origin.dentry) ||
>> +           !(origin.dentry->d_flags & DCACHE_DISCONNECTED)) {
>
> I don't understand the above test.
>
> If origin is a connected directory, then we have a chance of being
> able to lookup the overlay inode in the icache.
>
> If origin is a disconnected directory, then we don't have a chance,
> because if overlay dentry was cached, it would hold a ref to the
> connected origin.
>
> If origin is a non-dir, then we just don't care about being disconnected or not.
>
> So test should be
>
>         if (!d_is_dir(origin.dentry) || !(origin.dentry->d_flags &
> DCACHE_DISCONNECTED))
>
> What am I missing?

Probably my mistake.
I will look into it.

Thanks,
Amir.
