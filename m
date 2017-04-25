From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 05/11] ovl: lookup redirect by file handle
Date: Tue, 25 Apr 2017 20:41:32 +0300
Message-ID: <CAOQ4uxhu4LVJ-MAjH6McK31MYZ8__RkjCoK31kqJ-7fA2gu+SA@mail.gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
 <1493025256-27188-6-git-send-email-amir73il@gmail.com> <CAJfpegtz0emDRTHDrq0CrSZXAcovrLAAsX+-WkPGDRbyZD5vOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36538 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1176604AbdDYRld (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 25 Apr 2017 13:41:33 -0400
In-Reply-To: <CAJfpegtz0emDRTHDrq0CrSZXAcovrLAAsX+-WkPGDRbyZD5vOw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Apr 25, 2017 at 6:13 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, Apr 24, 2017 at 11:14 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> When overlay.fh xattr is found in a directory inode, instead of lookup
>> of the dentry in next lower layer by name, first try to get it by calling
>> exportfs_decode_fh().
>>
>> On failure to lookup by file handle to lower layer, fall back to lookup
>> by name with or without path redirect.
>>
>> For now we only support following by file handle from upper if there is a
>> single lower layer, because fallback from lookup by file hande to lookup
>> by path in mid layers is not yet implemented.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/overlayfs/namei.c     | 185 +++++++++++++++++++++++++++++++++++++++++++----
>>  fs/overlayfs/overlayfs.h |   1 +
>>  fs/overlayfs/util.c      |  14 ++++
>>  3 files changed, 186 insertions(+), 14 deletions(-)
>>
[...]
>>
>> +/* Check if p1 is connected with a chain of hashed dentries to p2 */
>> +static bool ovl_is_lookable(struct dentry *p1, struct dentry *p2)
>> +{
>> +       struct dentry *p;
>> +
>> +       for (p = p2; !IS_ROOT(p); p = p->d_parent) {
>> +               if (d_unhashed(p))
>> +                       return false;
>> +               if (p->d_parent == p1)
>> +                       return true;
>> +       }
>> +       return false;
>> +}
>
> Walking the dentry tree without RCU protection is dangerous and broken.
>

I wonder if is_subdir() would be correct here?
Or I could just follow its lead to implement the parent walk correctly.
I did want to verify that the found dentry is not only 'connected' to
root, but also 'lookable', because I don't want to find a deleted file
when looking in lower layers.
Maybe that was too much and in any case, I could just verify that
the decoded dentry itself is hashed.

> I'm also wondering if there's a better way to find the layer

The purpose of this test is not only to find the layer, but
also to verify that the found inode is linked under the layer root.
I think that decode_fh() will always be able to create a disconnected
dentry if decoding an inode that is on the same sb as the layer where
fh was encoded. I'm pretty sure this was what I found in my initial
tests which made me write the broken ovl_is_lookable().

> (e.g. store the layer index in the handle as well).
>

But the layer index is a volatile number that can change.
I would like to be able to find by fh also when more layers are added
to the stack.

The only thing I can think of is to store sb_uuid+layer_root_fh+lower_fh.
At mount, we build a hash of the lower sb_uuid (save same_lower_uuid
for now).
At lookup, we first find lower_sb by uuid (verify same_lower_uuid for now),
then decode lower_root by root_fh, then find lower_mnt by lower_root,
then decode lower_fh with lower_mnt.

Sound reasonable?
