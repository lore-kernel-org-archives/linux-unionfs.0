Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180316150634.GB4523@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com> <20180306205408.23383-16-vgoyal@redhat.com>
 <CAOQ4uxhey5gG+oB1BUM465-S29rBgU90T8iAwE3Nb5KxWoWepA@mail.gmail.com>
 <20180314191533.GB1001@redhat.com> <20180315184726.GD13357@redhat.com>
 <CAOQ4uxhcmffRaJ3511aoLCPv_D3=QWFVfZ95gHMkbqyDVLksZQ@mail.gmail.com>
 <20180316125209.GA4523@redhat.com> <CAOQ4uxhrbMSLoX02t-JyRx7EySwECe9sPUVnKLUu-FwNm00Kxw@mail.gmail.com>
 <20180316150634.GB4523@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 16 Mar 2018 18:09:31 +0200
Message-ID: <CAOQ4uxj6qewvuhUZdN=0STarG=cB8RpXLnkXOWwK874Jsvzh2w@mail.gmail.com>
Subject: Re: [PATCH v12 15/17] ovl: Remove redirect when data of a metacopy
 file is copied up
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Mar 16, 2018 at 5:06 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Mar 16, 2018 at 03:17:47PM +0200, Amir Goldstein wrote:
[...]
>
> I am just trying to understand this nlink stuff and associated locking
> better. It has confused me many a times.
>

There are only two rules to understand:
1. The delta between upper nlink and union nlink doesn't change on link()
    unlink() rename()
2. The delta between lower nlink and union nlink doesn't change op copyup

So all we need to do to make union nlink crash consistent is make sure
that we store NLINK xattr relative to lower before copyup and store it
relative to upper nlink before link/unlink/rename.

If we allow copyup (of lower hardlink) and link (of upper hardlink) at the
same time, we cannot guaranty crash consistency of union nlink.

> Can you give me an example where things will go wrong if we drop the
> lock after setting ovl_set_nlink_upper(). I have spent enough time
> thinking about it and can't think what will go wrong.
>

lower nlink = 2
upper nlink = 2 (1 copy up and 1 index)
union nlink = 2
NLINK xattr = "U+0"

start link():
oi->lock
store NLINK xattr = "U+0"
oi->unlock
...
ovl_do_link() (but not yet inc_nlink(inode))

start copyup():
oi->lock
store NLINK xattr = "L+0"
copy up inode
store NLINK xattr = "U-2" (because upper nlink is now 4, but
inode->i_nlink is still 2)

CRASH

BOOT

ovl_get_nlink()

lower nlink = 2
upper nlink = 4 (2 copy ups, 1 hardlink and 1 index)
NLINK xattr = "U-2"
union nlink = 2 (WRONG should be 3)

Now unlink the 2 copy ups and the new hardlinks and you hit
WARN_ON(inode->i_nlink == 0) in drop_nlink()

Hope I got this right...


>>
>> What is exactly the problem that you are trying to solve?
>> It seems that you need to protect oi->redirect in copyup/rename/link.
>> copyup/link already take the oi->lock and rename takes oi->lock
>> on new inode in case of "overwrite".
>> A simple solution would be to call ovl_nlink_start()/ovl_nlink_end()
>> in rename for both old and new inodes, regardless of "overwrite".
>> It may be unneeded, but in fact, ovl_nlink_start() doesn't do
>> anything wrong, it just recomputes NLINK xattr and most of those
>> recomputes will store the same value anyway, unless machine crashes
>> during copyup between ovl_set_nlink_lower() and
>> ovl_set_nlink_upper() and leaves the value of NLINK xattr relative to
>> lower nlink.
>
> ovl_nlink_start() also assumes that file is indexed. metadata copy up
> stuff does not have dependency on index.

That's probably ok because you can set independent redirects on
different broken hardlinks of the same lower.

>
> So I am instead passing "locked" state to ovl_set_redirect() and
> ovl_get_redirect(), and if oi->lock is not already held, then
> these functions will acquire it for non-dir.

Sounds ok.

>
> I meant to ask you one more question. Without indexing it is possible
> that two upper layer hardlinks (broken hardlinks), have redirects to
> same lower. I know that for the case of directories, you don't want
> two redirects to same lower. I am wondering what's the problem it
> leads to and if same problem applies for non-dir as well?

Yes, see in the test:
https://github.com/amir73il/xfstests/blob/overlayfs-devel/tests/overlay/049#L98

two redirects can have the same st_ino if lower nlink == 1 and
they are not indexed.

Thanks,
Amir.
