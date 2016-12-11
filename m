From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL] overlayfs update for 4.10
Date: Sun, 11 Dec 2016 14:51:15 +0100
Message-ID: <CAJfpegtfaZM4GAJSom9YqCv=hB8e7CGOcKzcyWtCqPtoDo-b=w@mail.gmail.com>
References: <20161210204926.GL2622@veci.piliscsaba.szeredi.hu> <20161211021218.GK1555@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35628 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753220AbcLKNvR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 11 Dec 2016 08:51:17 -0500
Received: by mail-oi0-f65.google.com with SMTP id v84so7892889oie.2
        for <linux-unionfs@vger.kernel.org>; Sun, 11 Dec 2016 05:51:17 -0800 (PST)
In-Reply-To: <20161211021218.GK1555@ZenIV.linux.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Sun, Dec 11, 2016 at 3:12 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sat, Dec 10, 2016 at 09:49:26PM +0100, Miklos Szeredi wrote:
>> Hi Al,
>>
>> I usually send overlayfs pulls directly to Linus, but it it suits you, please
>> feel free to pull from:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus
>>
>> This update contains:
>>
>>  - try to clone on copy-up;
>>  - allow renaming a directory;
>>  - fix data inconsistency of read-only fds after copy up;
>>  - misc cleanups and fixes.
>
>         Miklos, I'm very tempted to just let Linus do the... explaining
> why "ovl: add infrastructure for intercepting file ops" is not nicely done.
> It relies upon so damn many subtle things that result is a minefield for
> any later work.  If nothing else, you've just created a magical place that
> will have to be modified every time somebody adds a method.  Moreover, ->open()
> instances have every right to expect that nothing will change ->f_op after
> they return, period.  That includes things like later comparisons of ->f_op
> with known pointers, etc.
>
> Worse, there's nothing to prohibit embedding file_operations into an object
> with lifetime shorter than that of a module.  Your approach will blow up on
> those.  Sure, at the moment all of them live on weird filesystems that will be
> (hopefully) rejected before you get to that point.  With no promise whatsoever
> that this situation will persist.
>
> overlayfs is already one hell of a special snowflake, but this is just plain
> ridiculous - that sticks its fingers into so many places that making sure they
> don't get squashed will be very hard.  IMO that kind of stuff is on the
> "this should be handled by VFS or not at all" side of things, and I'm not
> at all sure that doing that anywhere is a good idea.

Let me just argue back with what happened with f_path.  We've seen the
breakage, and still nothing guarantees that filesystems won't assume
f_path.dentry isn't theirs.   This isn't much different IMO, except I
suspect the fallout from this will be much much smaller than from the
f_path change.  Having said that, I can try fixing in the VFS but I
suspect you won't like it much better.

And I tend to agree with you about the usefulness of this whole
change.  However (intelligent) people will argue about not building on
overlayfs because it's "not a POSIX fs" having quirks like this.  So
it's really the perception that needs to be fixed, and AFAICS the only
way to fix that is to fix the quirks.


> PS: macros like
> +#define OVL_CALL_REAL_FOP(file, call) \
> +       ({ struct ovl_fops *__ofop =                                     \
> +                       container_of(file->f_op, struct ovl_fops, fops); \
> +          WARN_ON(__ofop->magic != OVL_FOPS_MAGIC) ? -EIO :             \
> +                  __ofop->orig_fops->call;                              \
> +       })
>
> with uses along the lines of
> +               return OVL_CALL_REAL_FOP(file,
> +                                        fsync(file, start, end, datasync));
> make some things (like, you know, "find all places where a method could
> be called") harder for no good reason.

Makes sense.  I can expand them inline.

>
> While we are at it,
> +               module_put(ofop->owner);
> +               fops_put(ofop->orig_fops);
> is wrong - if that was the last reference to a module, your fops_put()
> might very well try and access a vfree'd area...

Yeah the order is wrong.  Will fix.

Thanks,
Miklos
