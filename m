From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v7 09/14] ovl: A new xattr OVL_XATTR_METACOPY for file on upper
Date: Mon, 20 Nov 2017 17:18:48 +0200
Message-ID: <CAOQ4uxjGteNfefP-FbF06okCCmuDruJ1gOkW=8NhEAn8BE7pOg@mail.gmail.com>
References: <20171116220335.13448-1-vgoyal@redhat.com> <20171116220335.13448-10-vgoyal@redhat.com>
 <CAOQ4uxgb0mC2qEAL0AbC7qY-Hv+PcoHMXhfadqojhA=iPHuh1Q@mail.gmail.com>
 <20171117203443.GE15566@redhat.com> <CAOQ4uxiTOU7RcXdBmewcUe8_Yh-N6+heJKNn2CMo0zuw4YLBRg@mail.gmail.com>
 <20171120143455.GA16840@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:33296 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751347AbdKTPSt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 20 Nov 2017 10:18:49 -0500
Received: by mail-yw0-f169.google.com with SMTP id z125so2958461ywb.0
        for <linux-unionfs@vger.kernel.org>; Mon, 20 Nov 2017 07:18:49 -0800 (PST)
In-Reply-To: <20171120143455.GA16840@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Mon, Nov 20, 2017 at 4:34 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Sat, Nov 18, 2017 at 09:06:41AM +0200, Amir Goldstein wrote:
>
> [..]
>> >> > Note, we now set OVL_UPPERDATA on all kind of dentires and check
>> >> > OVL_UPPERDATA only where it makes sense. If a file is created on upper,
>> >> > we set OVL_UPPERDATA. This can be accessed lockless in ovl_d_real()
>> >> > path again. This time ordering dependency is w.r.t oe->__upperdata. We
>> >> > need to make surr OVL_UPPERDATA is visible before oe->__upperdata is
>> >> > visible. Otherwise following code path might try to copy up an upper
>> >> > only file.
>> >>
>> >> Why all this explanations?
>> >> Just use ovl_set_upperdata() when creating upper and be done with it.
>> >
>> > Just using ovl_set_upperdata() will not do away with ordering dependency
>> > right? I mean, setting OVL_UPPERDATA in file creation path has different
>> > ordering requirement (same is the case of >has_upper). And I wanted to
>> > highlight that ordering requirement in changelogs.
>> >
>> > I can get rid of it. But this seems such a subtle requirement, I think
>> > its a good idea to talk about it explicitly.
>> >
>>
>> I am not following. you only need to ovl_set_upperdata() before
>> ovl_inode_update(), just like in regular copy up. Am I missing something
>> subtle?
>
> Hi Amir,
>
> Right. This is ordering dependency between setting of OVL_UPPERDATA and
> oi->__upperdentry.
>
> So as per barrier documentation file, read/write barrier should look
> as follows.
>
>         CPU1                            CPU2
>      set OVL_UPPERDATA                  smp_rmb()
>      smp_wmb()                          Load oi->__upperdentry
>      set oi->__upperdentry
>
> So we need to place smp_wmb() after setting OVL_UPPERDATA and place
> smp_rmb() just before load of oi->__upperdentry.
>
> Instead of smp_rmb() we are relying on checking for ovl_dentry_lower().
> That is even if OVL_UPPERDATA is not visible on CPU2, but
> oi->__upperdentry is visible, then we don't try to copy up a file which
> does not have a lower.
>
> So ovl_dentry_lower() is preventing the race which *in-theory* can trigger
> trying to copy up file which does not have lower.
>
> Does this make sense?
>

Maybe. Brain overflow.
To put it shortly, if there is a problem with setting OVL_UPPERDATA on new upper
then there is a problem with setting upper alias as well (as you pointed out).
I don't think that is really the case, but I am not the one to explain why.
It just does not make sense that d_instantiate doesn't make sure that inode
fields are consistent before attaching the inode to dentry.
I think the barriers hide in raw_write_seqcount_begin()/raw_seqcount_begin()
for the lockless dentry cache lookup, but I'm not an expert.

Anyway, I find the commit message text from "If a file is created on upper,..."
very confusing.
I suggest that if you are not sure about this leave a "XXX" comment in the
code path of creating new upper and setting  OVL_UPPERDATA flag or
"TODO" comment if you thing there is something to be done.

It is easy to later apply a patch to remove the XXX comment after explaining it
or remove TODO comment after fixing it.
A confusing text remains in git log forever and get git history
researchers off track.

Amir.
