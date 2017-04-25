From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 05/11] ovl: lookup redirect by file handle
Date: Tue, 25 Apr 2017 22:11:51 +0300
Message-ID: <CAOQ4uxiGwd-h2kJVLKkbyBC9YD_a=19ta1HB0F9KueqL_Pr3XA@mail.gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
 <1493025256-27188-6-git-send-email-amir73il@gmail.com> <CAJfpegtz0emDRTHDrq0CrSZXAcovrLAAsX+-WkPGDRbyZD5vOw@mail.gmail.com>
 <CAOQ4uxhu4LVJ-MAjH6McK31MYZ8__RkjCoK31kqJ-7fA2gu+SA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35555 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1429537AbdDYTLw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 25 Apr 2017 15:11:52 -0400
In-Reply-To: <CAOQ4uxhu4LVJ-MAjH6McK31MYZ8__RkjCoK31kqJ-7fA2gu+SA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Apr 25, 2017 at 8:41 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, Apr 25, 2017 at 6:13 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Mon, Apr 24, 2017 at 11:14 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> When overlay.fh xattr is found in a directory inode, instead of lookup
>>> of the dentry in next lower layer by name, first try to get it by calling
>>> exportfs_decode_fh().
>>>
>>> On failure to lookup by file handle to lower layer, fall back to lookup
>>> by name with or without path redirect.
>>>
>>> For now we only support following by file handle from upper if there is a
>>> single lower layer, because fallback from lookup by file hande to lookup
>>> by path in mid layers is not yet implemented.
>>>
>>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>>> ---
>>>  fs/overlayfs/namei.c     | 185 +++++++++++++++++++++++++++++++++++++++++++----
>>>  fs/overlayfs/overlayfs.h |   1 +
>>>  fs/overlayfs/util.c      |  14 ++++
>>>  3 files changed, 186 insertions(+), 14 deletions(-)
>>>
> [...]
>>>
>>> +/* Check if p1 is connected with a chain of hashed dentries to p2 */
>>> +static bool ovl_is_lookable(struct dentry *p1, struct dentry *p2)
>>> +{
>>> +       struct dentry *p;
>>> +
>>> +       for (p = p2; !IS_ROOT(p); p = p->d_parent) {
>>> +               if (d_unhashed(p))
>>> +                       return false;
>>> +               if (p->d_parent == p1)
>>> +                       return true;
>>> +       }
>>> +       return false;
>>> +}
>>
>> Walking the dentry tree without RCU protection is dangerous and broken.
>>
>
> I wonder if is_subdir() would be correct here?
> Or I could just follow its lead to implement the parent walk correctly.
> I did want to verify that the found dentry is not only 'connected' to
> root, but also 'lookable', because I don't want to find a deleted file
> when looking in lower layers.
> Maybe that was too much and in any case, I could just verify that
> the decoded dentry itself is hashed.
>
>> I'm also wondering if there's a better way to find the layer
>
> The purpose of this test is not only to find the layer, but
> also to verify that the found inode is linked under the layer root.
> I think that decode_fh() will always be able to create a disconnected
> dentry if decoding an inode that is on the same sb as the layer where
> fh was encoded. I'm pretty sure this was what I found in my initial
> tests which made me write the broken ovl_is_lookable().
>
>> (e.g. store the layer index in the handle as well).
>>
>
> But the layer index is a volatile number that can change.
> I would like to be able to find by fh also when more layers are added
> to the stack.
>
> The only thing I can think of is to store sb_uuid+layer_root_fh+lower_fh.
> At mount, we build a hash of the lower sb_uuid (save same_lower_uuid
> for now).
> At lookup, we first find lower_sb by uuid (verify same_lower_uuid for now),
> then decode lower_root by root_fh, then find lower_mnt by lower_root,
> then decode lower_fh with lower_mnt.
>
> Sound reasonable?

Or maybe like this:

At mount time either set or verify the xattr in upper layer root inode:
overlay.root.$i [i:=0..numlower-1] - ovl_root_id of lower layer i
ovl_root_id includes for each layer:
- sb uuid
- fh of root inode

If mount was able to set or verify that all ovl_root_id[i] match their
respective lower layer sb and root inode, then redirect_fh can be enabled,
otherwise it is disabled.

With redirect_fh enabled, it is safe to lookup by the lower layer index,
root fh and lower inode fh.
With redirect_fh enabled, it is safe to store handles on copy up along
with lower layer index and root fh.

A lower layer can be used and reused by any number of overlay mounts
at different layer index.

An upper layer can be reused in an overlay mount with either copied lower
layers or with different lower stack and will have redirect_fh disabled.

An upper layer can be rotated as lower layer, because file handles are
never followed from a lower layer. Constant inode numbers code does
not need to follow by fh from lower layers.

With this scheme, there is no need to store nor match sb_uuid a for
every single copy up and every single lookup by fh.
There is no need to 'lookup' the layer, just use the index and compare
the root_fh.

It is quite safe from following handles to wrong fs, except if user copies
parts of an upper layer (without the layer root), but doing something like
that is equivalent to a user that takes down an NFS server, brings up
a server with the same network address and exports the same share
name from a different filesystem.

Maybe the chances are more slim, but the same interesting things could
happen.

Amir.
