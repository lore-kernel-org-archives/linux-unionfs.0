MIME-Version: 1.0
In-Reply-To: <20180510193913.GA11152@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
	<20180507174102.24086-11-vgoyal@redhat.com>
	<CAJfpegvzDAMx66TMhHTacYEUpowRcEYKkFuhD+TQoV83MfXPmQ@mail.gmail.com>
	<20180510193913.GA11152@redhat.com>
Date: Thu, 10 May 2018 22:13:50 +0200
Message-ID: <CAJfpeguVb-u2Tzrz2f1L3bgE8QS+cwhCpBsfW3=+J8s-jZerBw@mail.gmail.com>
Subject: Re: [PATCH v15 10/30] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, May 10, 2018 at 9:39 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, May 10, 2018 at 11:19:23AM +0200, Miklos Szeredi wrote:
>
> [..]
>> > @@ -925,18 +943,36 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>> >                  * When "verify_lower" feature is enabled, do not merge with a
>> >                  * lower dir that does not match a stored origin xattr. In any
>> >                  * case, only verified origin is used for index lookup.
>> > +                *
>> > +                * For non-dir dentry, make sure dentry found by lookup
>> > +                * matches the origin stored in upper. Otherwise its an
>> > +                * error.
>>
>> Umm, why we need to be so strict?  This would  break the case where
>> the layers are copied with xattr intact, but the origin pointer will
>> obviously be "wrong", which shouldn't be a problem, since that's only
>> needed to get a unique st_ino, nothing else.
>
> So I have few questions at this point of time, I am not clear about what
> should be the behavior.
>
> - Layer copying does not work with index=on. So if index is on, it is fair
>   to assume that layer copying will not be allowed and that configuration
>   is not supported. If yes, then we could enforce this check with index=on
>   and not in other cases.

It does work, except for hard links.  If we unconditionally add
redirects to hard links, then fsck.overlay can recreate the index on
the copied version.


>
> - If we do not enforce ORIGIN verification for non-dir metacopy and
>   overlay is mounted again after layer copy, then before data copy up we
>   will report inode number of lowerstack[0]. And after data copy up it
>   could be inode number of any of the following.
>
>   A. lower inode (if previous overlay dentry has not been flushed, it will
>                   have CONST_INO set.).
>   B. upper inode (if previous overlay dentry got flushed out, and new
>      lookup could not decode ORIGIN).
>
>   C. older lower inode (if previous overlay dentry got flushed out, and
>      new lookup decoded previous inode before layer copy up.)
>
> I guess both B and C will happen with existing code even with normal copy
> up. So this behavior with metacopy files might not be a huge concern.

How about this:

 - if upper has REDIRECT, then use that to determine origin (just like
directories)
 - else if upper has METACOPY, then go down one level to determine
origin (just like directories)
 - else if upper has ORIGIN, then use that as origin (not applicable
to directories (*))
 - else no origin (just like directories)

Haven't yet thought about how that works out in various layer copy scenarios...

Thanks,
Miklos

(*) There's a similar case for directories caused by
ovl_clear_empty().  If the opaque empty dir created in place of the
directory with whiteouts manages to survive due to failure to remove,
then it will have ORIGIN but layers won't be followed because it's
opaque.  We do not correctly handle this corner case, though, so we'd
see the inode number of the directory change in this case.
