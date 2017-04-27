From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 05/11] ovl: lookup redirect by file handle
Date: Thu, 27 Apr 2017 09:27:13 +0300
Message-ID: <CAOQ4uxiGzp2G3qSC7be3nVnvjYJZuHAmY7Q1Oc+jM+pZWtuHig@mail.gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
 <1493025256-27188-6-git-send-email-amir73il@gmail.com> <CAJfpegtz0emDRTHDrq0CrSZXAcovrLAAsX+-WkPGDRbyZD5vOw@mail.gmail.com>
 <CAOQ4uxhu4LVJ-MAjH6McK31MYZ8__RkjCoK31kqJ-7fA2gu+SA@mail.gmail.com>
 <CAOQ4uxiGwd-h2kJVLKkbyBC9YD_a=19ta1HB0F9KueqL_Pr3XA@mail.gmail.com>
 <CAJfpegssdQ4E=uY3bq8zgXLHZsOQaJXpMWtCZ+V=yVM8vmcw5w@mail.gmail.com>
 <CAOQ4uxgPpnnc5dC+PSuOOWdpnobdKZNzgBzmbeW4Lw6P8_--hg@mail.gmail.com>
 <CAJfpeguaePn++tZBvd-2Z68a_8WGfy7EuWLzODyv60E45C6WSQ@mail.gmail.com>
 <CAOQ4uxiozume+xj4KHiDTwqgWmmXKL+6Ksw1EDWXuZYDFa2KVQ@mail.gmail.com>
 <CAJfpegtv4kN4d7ti5f5p=51aQk8U2UT9xdsvZkYoXWOfQ5BNcQ@mail.gmail.com> <CAOQ4uxhi4GReBbBzd8NdCJ+emzMEa1COYAtcaKziMiaZAV96uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxhi4GReBbBzd8NdCJ+emzMEa1COYAtcaKziMiaZAV96uw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Apr 26, 2017 at 5:51 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Apr 26, 2017 at 3:15 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Wed, Apr 26, 2017 at 12:17 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> On Wed, Apr 26, 2017 at 12:55 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>> On Wed, Apr 26, 2017 at 11:40 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>>
>>>>> Just to see that I understand you correctly.
>>>>>
>>>>> I am now working on storing the following:
>>>>>
>>>>> /*
>>>>>  * The tuple origin.{fh,layer,uuid} is a universal unique identifier
>>>>>  * for a copy up origin, where:
>>>>>  * origin.fh    - exported file handle of the lower file
>>>>>  * origin.root - exported file handle of the lower layer root
>>>>>  * origin.uuid  - uuid of the lower filesystem
>>>>
>>>> I wouldn't even store origin.root.
>>>>
>>>>>  *
>>>>>  * origin.{fh,root} are stored in format of a variable length binary blob
>>>>>  * with struct ovl_fh header (total blob size up to 20 bytes).
>>>>>  * uuid is stored in raw format (16 bytes) as published by sb->s_uuid.
>>>>>  */
>>>>>
>>>>> I intend to implement lookup as follows:
>>>>> - compare(origin.uuid, same_lower_sb->s_uuid)
>>>>> # layer root dentries cannot be DCACHE_DISCONNECTED, so
>>>>> # exportfs_decode_fh ignores mnt arg and returns the cached dentry
>>>>> - root = exportfs_decode_fh(lowerstack[0].mnt, origin.root)
>>>>> - find layer where lowerstack[layer].dentry == root
>>>>> - this = exportfs_decode_fh(lowerstack[layer].mnt, origin.fh)
>>>>>
>>>>> is_subdir() is NOT needed for decoding the layer root
>>>>> is_subdir() is optional for decoding the lower file, because
>>>>> it is not needed to identify the layer
>>>>
>>>> Hmm, we can just force exportfs_decode_fh() to return a connected
>>>> dentry (return false from *acceptable() if the dentry is disconnected)
>>>> before going on to iterate the layers to see which one contains it.
>>>>
>>>
>>> Hmm, this might work, but to quote from exportfs_decode_fh():
>>> "It's not a directory.  Life is a little more complicated."
>>>
>>> IIUC, 'connected' means 'connected to sb root', and not
>>> 'connected to mnt root', so in the optimal case where
>>> all lower dentries are cached,  exportfs_decode_fh() will return
>>> a connected dentry for every fh we give it regardless of the
>>> mnt argument, so we will have to use is_subdir() to find the
>>> right layer, which brings us back to O(numlower*depth)
>>
>> It just means that we might have to make up an artificial mount which
>> has its root at the sb root to be able to decode the handle into a
>> connected one.
>>
>
> I'm not sure I understand what this artificial mount buys us.

Let me try to explain the problem with a worse case, but not
improbable example:

Suppose I have an overlay with deep file at /a/b/c/.../z
Suppose the layers are at /old/{lower,upper} I copy them
over to /new/{lower,upper} and mount the overlay at new path.

Suppose that dcache is fully populated under /new and fully
evicted under /old.

When trying to decode the file handle for z, exportfs_decode_fh()
will call the file system to actually read all directories a..z from disk
in order to reconnect the dentry of old z all the way up to /old
and it will do that *before* calling the acceptable() callback.

Alternatively, if we first try to decode the file handle for /old/lower,
decoding will be very fast (most likely already in cache) and we will
not have to continue to decoding z and reading all directories a..z
from disk.

This is why and how I implemented lookup by origin.{root+fh}
in v3 patch set.

>
>>>
>>> With the extra cost of storing the deducible information origin.root,
>>> we will have less complex and more efficient lookup code.
>>>
>>> Let me try and implement it and see if I am right.
>>> We can always discard origin.root from v4 if it turns
>>> out to be unhelpful.
>>
>> I don't have good feelings about storing the root fh just because we
>> don't special case the layer root anywhere yet, and I wouldn't want to
>> do that unless there's a good reason.
>>

Wait, what do you mean by "we don't special case the layer root?"
Do you mean that we could mount an overlay at a subdir path?
i.e. in the example below, we could mount an overlay with
upperdir=/new/upper/a/b/c,lowerdir=/new/lower/a/b/c?

If this is what you mean then it is not true that we don't special case
layer root. We do it with path redirect relative to layer root.
If anything, we should be storing origin.root along with overlay.redirect
in order to verify that we are not redirecting into the wrong relative
path.

>
> There are a few reasons for origin.root, not sure if they are good:
> 1. lookup is O(numlower+depth) instead of O(numlower*depth)
> 2. origin.uuid validates that we are still on the same sb
>     origin.root validates that we are still using the same lower dirs
>     and that files from old lower were not moved around to find themselves
>     inside a different lower dir
> 3. hardlinks between layers (!!!) will still get to the right layer
>
> I personally think that reason #1 is the important one, but I think we
> disagree on the technical details of exportfs_decode_fh() and we
> need to sort this out.
>
> Here is my untested implementation of find layer by uuid/rootfh
> with the relevant comments. Maybe it helps you point out what
> I am missing or what you are missing:
>
> /* Find lower layer index by layer root file handle and uuid */
> static int ovl_find_layer_by_fh(struct dentry *dentry, struct
> ovl_lookup_data *d)
> {
>         struct ovl_entry *roe = dentry->d_sb->s_root->d_fsdata;
>         struct super_block *lower_sb = ovl_same_lower_sb(dentry->d_sb);
>         struct dentry *this;
>         int i;
>
>         /*
>          * For now, we only support lookup by fh for all lower layers on the
>          * same sb.  Not all filesystems set sb->s_uuid.  For those who don't
>          * this code will compare zeros, which at least ensures us that the
>          * file handles are not crossing from filesystem with sb->s_uuid to
>          * a filesystem without sb->s_uuid and vice versa.
>          */
>         if (!lower_sb || memcmp(lower_sb->s_uuid, &d->uuid, sizeof(d->uuid)))
>                 return -1;
>
>         /*
>          * Layer root dentries are pinned, there are no aliases for dirs, and
>          * all lower layers are on the same sb.  If rootfh is correct,
>          * exportfs_decode_fh() will find it in dcache and return the only
>          * instance, regardless of the mnt argument and we can compare the
>          * returned pointer with the pointers in lowerstack.
>          */
>         this = ovl_decode_fh(roe->lowerstack[0].mnt, d->rootfh, ovl_is_dir);
>         if (IS_ERR(this))
>                 return -1;
>
>         for (i = 0; i < roe->numlower; i++) {
>                 if (this == roe->lowerstack[i].dentry)
>                         break;
>         }
>
>         dput(this);
>         return i < roe->numlower ? i : -1;
> }
>
> Amir.
