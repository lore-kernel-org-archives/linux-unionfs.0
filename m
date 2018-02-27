Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxgTrL=fNedkfPvqvPB4m7z5u1cbf2e_h_FSxvzU+f0ANQ@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
 <1515086449-26563-11-git-send-email-amir73il@gmail.com> <CAOQ4uxgTrL=fNedkfPvqvPB4m7z5u1cbf2e_h_FSxvzU+f0ANQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 27 Feb 2018 13:35:05 +0200
Message-ID: <CAOQ4uxj4hqQrDUUd0hQ_t=PapcsFQ2Mj5=kv5Rp9q5AeAQ6WEw@mail.gmail.com>
Subject: Re: [PATCH v2 10/17] ovl: decode lower file handles of unlinked but
 open files
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Jan 18, 2018 at 4:18 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, Jan 4, 2018 at 7:20 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Lookup overlay inode in cache by origin inode, so we can decode a file
>> handle of an open file even if the index has a whiteout index entry to
>> mark this overlay inode was unlinked.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/overlayfs/export.c    | 22 ++++++++++++++++++++--
>>  fs/overlayfs/inode.c     | 16 ++++++++++++++++
>>  fs/overlayfs/overlayfs.h |  1 +
>>  3 files changed, 37 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
>> index 602bada474ba..6ecb54d4b52c 100644
>> --- a/fs/overlayfs/export.c
>> +++ b/fs/overlayfs/export.c
>> @@ -385,13 +385,21 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
>>         struct ovl_path *stack = &origin;
>>         struct dentry *dentry = NULL;
>>         struct dentry *index = NULL;
>> +       struct inode *inode = NULL;
>> +       bool is_deleted = false;
>>         int err;
>>
>>         /* First lookup indexed upper by fh */
>>         index = ovl_get_index_fh(ofs, fh);
>>         err = PTR_ERR(index);
>> -       if (IS_ERR(index))
>> -               return ERR_PTR(err);
>> +       if (IS_ERR(index)) {
>> +               if (err != -ESTALE)
>> +                       return ERR_PTR(err);
>> +
>> +               /* Found a whiteout index - treat as deleted inode */
>> +               is_deleted = true;
>> +               index = NULL;
>
> Ouch! it seems I was misleading you.
> If we find a whiteout index for dir, we *do* decode+reconnect origin,
> because we want to find out if this is an unlinked but open non-dir.
> I guess there are 2 ways to avoid this unneeded decode:
> 1. mark a "directory index whiteout" differently than "non-dir index whiteout"
> 2. lookup icache by file handle
>

Getting back to this.
I have implemented lookup icache by file handle and realized that it incurs
higher CPU usage in the common case because the hash function is more
expensive. I do not have benchmark numbers to present.

However, I also realized there is a 3rd option, which seems like a
better option:

- Call the underlying fs fh_to_dentry() operation (and not exportfs_decode_fh())
  to get a possibly disconnected origin dentry
- Lookup overlay inode by origin inode
- IF overlay inode not cached lookup index by origin fh
- IF origin dentry is a disconnected directory AND overlay inode is not cached
  AND index is not found, only then call exportfs_decode_fh() of origin fh
  to reconnect the origin dir

I'll try to write this up.

Thanks,
Amir.
