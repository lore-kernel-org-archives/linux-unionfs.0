From: Krisztian Litkey <kli@iki.fi>
Subject: Re: [PATCH v3 1/1] ovl: setxattr: don't deadlock when called from ima_fix_xattr.
Date: Fri, 20 May 2016 23:53:18 +0300
Message-ID: <CAH4bDXjHjPSYAoQB8VODcDG2MRz30ZQqtrm+x7BWG-2X8qhGAg@mail.gmail.com>
References: <1463611500.2465.22.camel@linux.vnet.ibm.com>
	<1463725718-2461-1-git-send-email-kli@iki.fi>
	<1463754087.2763.17.camel@linux.vnet.ibm.com>
	<20160520162937.GU14480@ZenIV.linux.org.uk>
	<1463763633.2763.34.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35337 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbcETUxV (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 20 May 2016 16:53:21 -0400
In-Reply-To: <1463763633.2763.34.camel@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, Krisztian Litkey <krisztian.litkey@intel.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel@vger.kernel.org

On Fri, May 20, 2016 at 8:00 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Fri, 2016-05-20 at 17:29 +0100, Al Viro wrote:
>> On Fri, May 20, 2016 at 10:21:27AM -0400, Mimi Zohar wrote:
>> > > + if (mutex_is_locked(&upper->d_inode->i_mutex))
>> > > +         err = __vfs_setxattr_noperm(upper, name, value, size, flags);
>> >
>> > As far as I'm aware, the only time that i_mutex is taken, is during
>> > __fput() when IMA writes security.ima.   Previous versions of this patch
>> > checked whether the xattr being written was security.ima.  It would
>> > probably be a good idea not to make that assumption here.   The question
>> > is what should happen if the i_mutex is locked, but the xattr isn't
>> > security.ima.  At minimum it should be audited.  Al, any comments?
>>
>> ITYM "printable", and that's somewhat harder.  OK, let me try:
>>
>> Anybody using ..._is_lock() kind of primitives that way ought to be
>> (re)educated before they are allowed near any kind of multithreaded
>> code _anywhere_.  mutex could've been held by a different thread of
>> execution and dropped just as mutex_is_locked() returns.  Or at any
>> subsequent point.  This is 100% bogus; one should *never* write that kind
>> of code.  As in "here's your well-earned F-, better luck next semester".
>>
>> I haven't seen the full patch (you've quoted only a part of that gem), but
>> about the only way for it to be correct is to have it continue with
>> + else
>> +       err = <identical call>
>>
>>       Practically all calls of mutex_is_locked() are of form
>> WARN_ON(!mutex_is_locked(...)) or equivalent thereof.  And the rest contains
>> similar... wonders - for example, take a look at drivers/media/rc/imon.c;
>> imon_ir_change_protocol() has this
>>         if (!mutex_is_locked(&ictx->lock)) {
>>                 unlock = true;
>>                 mutex_lock(&ictx->lock);
>>         }
>>
>>         retval = send_packet(ictx);
>>         if (retval)
>>                 goto out;
>>
>>         ictx->rc_type = *rc_type;
>>         ictx->pad_mouse = false;
>>
>> out:
>>         if (unlock)
>>                 mutex_unlock(&ictx->lock);
>> Finding why it's exploitably racy is left as a trivial exercise for readers...
>>
>> Folks, if you see something of that sort in the code, it's a huge red flag.
>> There are legitimate uses of mutex_is_locked other than asserts, but those
>> are extremely rare.
>
> My fault for even suggesting it.

Mimi, it is not your fault. I should have never missed something so
ridiculously trivial as this. I was simply being an idiot and rolled a
patch with my brain completely shut off and without stopping for
a single second to think about what I was doing. I agre with Al that
in that state of mind one should not be anywhere near a keyboard,
let alone trying to write kernel code. Got what I deserved.

>> I would need to see more context to be able to comment on the problem in
>> question, but this patch is almost certainly broken.
>
> We deferred __fput() back in 2012 in order for IMA to safely take the
> i_mutex and write security.ima.   Writing the security.ima xattr now
> triggers overlayfs to write the xattr, but overlayfs doesn't
> differentiate between callers - as a result of userspace or as described
> here in __fput().   All calls to ovl_setxattr() should call vfs_sexattr,
> except the one triggered by __fput().   Refer to the original lockdep
> report -
> http://thread.gmane.org/gmane.linux.file-systems.union/640

How about the other (maybe kludgy) option of adding a dedicated inode
flag for this, setting it in the call to __vfs_setxattr_noperm in ima_appraise
and forcibly clearing it in vfs_setxattr. ovl_setxattr could then test it and
branch accordingly...

>
> Al, any help in resolving this lockdep would be much appreciated.
>
> Mimi
>

Cheers,
  Krisztian the Idiot, hiding in a quiet corner, bowing his head in shame


> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
