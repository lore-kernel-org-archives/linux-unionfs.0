Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180307204329.GL5350@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com> <20180306205408.23383-15-vgoyal@redhat.com>
 <CAOQ4uxgpjtUU1i8STkVYERV3-moyawb7ffTtpWCBJPTOA8_afQ@mail.gmail.com>
 <20180307151519.GE5350@redhat.com> <CAOQ4uxhj7Qy9f65nJdB70vDqODnTB8jSsAE4Hr8xbo5ReAL-BA@mail.gmail.com>
 <20180307204329.GL5350@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 8 Mar 2018 10:04:31 +0200
Message-ID: <CAOQ4uxjmVDHr9-xmQ7Yx2xsnZ3TBw2wvjJkX-TS-+5cpV18oZw@mail.gmail.com>
Subject: Re: [PATCH v12 14/17] ovl: Set redirect on metacopy files upon rename
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Mar 7, 2018 at 10:43 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
[...]
>> >>
>> >> Q: why do you set samedir: = false here?
>> >> A: because other hardlink aliasses cannot follow a relative redirect, right?
>> >
>> > Right. If we create a hardlink later then it will need absolute redirect
>> > if both dentries are not in same dir.
>> >
>> >>
>> >> This is a subtle detail that should be documented,
>> >
>> > Ok, will do.
>> >
>> >> but also
>> >> maybe do use samedir if nlink == 1?
>> >
>> > Hmm.., so initially we could put a relative redirct (if nlink=1) and later
>> > if we create a link, we could replace relative redirect with an absolute
>> > redirect? I see we already have logic to do that for the case of rename.
>> >
>> > Now only thing I need to figure out in ovl_link() whethre two dentries
>> > are in same dir or not. I am assuming I can just check parent dentry
>> > pointers and see if these two have same parent or not.
>>
>> Yes or we can just convert to absolute path anyway for nlink > 1.
>> >
>> > In fact, we probably don't even have to check for nlink=1. Only when
>> > we create a upper hard link, then we need to make sure we replace relative
>> > hardlink with absolute one. I will play with it and see how it goes.
>> >
>>
>> Yes. alomst true. but we do need to check for lower nlink > 1,
>> because in that case (when index=on) upper hardlinks are created on
>> copy up not only on ovl_link(), so easiest is to just start with
>> absolute redirect
>> on rename of lower hardlink.
>
> Hmm..., even in that case it should work. For example, say foo.txt and
> bar.txt are hardlinked in lower. hence nlink=2. And now I rename foo.txt
> to foo-upper.txt, then it will be copied up (with index hardlinked) and
> then a redirect will be set (foo.txt). And now, bar.txt can be looked up
> without redirct and foo-upper.txt can be looked up with redirect. So it
> should work even in nlink>1 in lower. Can you give a specific example
> where it will be broken.
>

Suppose bar/bar.txt and foo/foo.txt. On metacopy up of bar.txt you need
to convert to absolute redirect. Because (with index=on) bar.txt will be
"linked up" to foo-upper.txt, which has a redirect xattr of "foo.txt".
On cold cache lookup of bar/bar.txt, metacopy lookup will follow "foo.txt"
redirect to "bar/foo.txt", which does not exist.

> Having said that I don't mind to always set absolute redirect whenever
> nlink > 1 (both in lower and upper) and that simplifies the logic a bit.
>

Yeh, we optimize the common case of nlink == 1 and same dir, because
absolute redirect is heavy on lookup, and we leave the less common case
of upper or lower hardlink simple and not optimized.

Thanks,
Amir.
