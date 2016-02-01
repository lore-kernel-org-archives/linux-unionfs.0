From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [PATCH] ovl: ignore lower entries when checking purity of
 non-directory entries
Date: Mon, 1 Feb 2016 18:43:19 +0300
Message-ID: <CALYGNiMzEHR3pfSr8cNhRyqS_4=QNOrNjtL69bpGuf6CiBJ5vw@mail.gmail.com>
References: <145424627339.27058.6895511767458306300.stgit@zurg>
	<20160201141424.GA1448@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160201141424.GA1448@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Feb 1, 2016 at 5:14 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Sun, Jan 31, 2016 at 04:17:53PM +0300, Konstantin Khlebnikov wrote:
>> After rename file dentry still holds reference to lower dentry from
>> previous location. This doesn't matter for data access because data
>> cames from upper dentry. But this stale lower dentry taints dentry
>> at new location and turns it into non-pure upper. Such file leaves
>> visible whiteout entry after remove in directory which shouldn't
>> have whiteouts at all.
>>
>> Overlayfs already tracks pureness of file location in oe->opaque.
>> This patch just uses that for detecting actual path type.
>>
>> Comment from Vivek Goyal's patch:
>>
>> Here are the details of the problem. Do following.
>>
>> $ mkdir upper lower work merged upper/dir/
>> $ touch lower/test
>> $ sudo mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work
>> merged
>> $ mv merged/test merged/dir/
>> $ rm merged/dir/test
>> $ ls -l merged/dir/
>> /usr/bin/ls: cannot access merged/dir/test: No such file or directory
>> total 0
>> c????????? ? ? ? ?            ? test
>>
>> Basic problem seems to be that once a file has been unlinked, a
>> whiteout has been left behind which was not needed and hence it becomes
>> visible.
>>
>> whiteout is visible because parent dir is of not type MERGE, hence
>> od->is_real is set during ovl_dir_open(). And that means ovl_iterate()
>> passes on iterate handling directly to underlying fs. Underlying fs does
>> not know/filter whiteouts so it becomes visible to user.
>>
>> Why did we leave a whiteout to begin with when we should not have.
>> ovl_do_remove() checks for OVL_TYPE_PURE_UPPER() and does not leave
>> whiteout if file is pure upper. In this case file is not found to be
>> pure upper hence whiteout is left.
>>
>> So why file was not PURE_UPPER in this case? I think because dentry is
>> still carrying some leftover state which was valid before rename. For example,
>> od->numlower was set to 1 as it was a lower file. After rename, this state
>> is not valid anymore as there is no such file in lower.
>>
>> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
>> Reported-by: Viktor Stanchev <me@viktorstanchev.com>
>> Diagnosed-by: Vivek Goyal <vgoyal@redhat.com>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=109611
>
> Hi Konstantin,
>
> Thanks for the patch. This patch works for me also does not break
> unionmount-testsuite.

Interesting. I haven't heard about this testsuite. Never read Documentation. =)

I've send couple of patches for xfstests: this case and fixed bugs in setattr.
This seems much better place for them.

>
> This change also sounds reasonable to me. (given we can't free lower). So
> over rename we will be keeping references to dentries which we should
> not have to. I guess there does not seem to be a better option.
>
> Acked-by: Vivek Goyal <vgoyal@redhat.com>
>
> Thanks
> Vivek
>
>
>
>> ---
>>  fs/overlayfs/dir.c   |    7 +++++++
>>  fs/overlayfs/super.c |   12 +++++++-----
>>  2 files changed, 14 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
>> index ed95272d57a6..edf83f325bca 100644
>> --- a/fs/overlayfs/dir.c
>> +++ b/fs/overlayfs/dir.c
>> @@ -903,6 +903,13 @@ static int ovl_rename2(struct inode *olddir, struct dentry *old,
>>       if (!overwrite && new_is_dir && !old_opaque && new_opaque)
>>               ovl_remove_opaque(newdentry);
>>
>> +     /*
>> +      * Old dentry now lives in different location. Dentries in
>> +      * lowerstack are stale. We cannot drop them here because
>> +      * access to them is lockless. This could be only pure upper
>> +      * or opaque directory - numlower is zero. Or upper non-dir
>> +      * entry - its pureness is tracked by flag opaque.
>> +      */
>>       if (old_opaque != new_opaque) {
>>               ovl_dentry_set_opaque(old, new_opaque);
>>               if (!overwrite)
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index 8d826bd56b26..ba28b007005e 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -76,12 +76,14 @@ enum ovl_path_type ovl_path_type(struct dentry *dentry)
>>       if (oe->__upperdentry) {
>>               type = __OVL_PATH_UPPER;
>>
>> -             if (oe->numlower) {
>> -                     if (S_ISDIR(dentry->d_inode->i_mode))
>> -                             type |= __OVL_PATH_MERGE;
>> -             } else if (!oe->opaque) {
>> +             /*
>> +              * Non-dir dentry can hold lower dentry from previous
>> +              * location. Its purity depends only on opaque flag.
>> +              */
>> +             if (oe->numlower && S_ISDIR(dentry->d_inode->i_mode))
>> +                     type |= __OVL_PATH_MERGE;
>> +             else if (!oe->opaque)
>>                       type |= __OVL_PATH_PURE;
>> -             }
>>       } else {
>>               if (oe->numlower > 1)
>>                       type |= __OVL_PATH_MERGE;
