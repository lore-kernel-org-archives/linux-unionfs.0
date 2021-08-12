Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 956A8C432BE
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Aug 2021 18:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6937C6109D
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Aug 2021 18:47:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbhHLSsQ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 14:48:16 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:35356 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhHLSsP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Aug 2021 14:48:15 -0400
Received: from in02.mta.xmission.com ([166.70.13.52]:49668)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mEFjy-00CfWJ-Ec; Thu, 12 Aug 2021 12:47:42 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:44640 helo=email.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mEFjx-00BaoL-09; Thu, 12 Aug 2021 12:47:42 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Peter Zijlstra \(Intel\)" <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Kees Cook <keescook@chromium.org>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mike Rapoport <rppt@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Chinwen Chang <chinwen.chang@mediatek.com>,
        Michel Lespinasse <walken@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
        Huang Ying <ying.huang@intel.com>,
        Jann Horn <jannh@google.com>, Feng Tang <feng.tang@intel.com>,
        Kevin Brodsky <Kevin.Brodsky@arm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Shawn Anastasio <shawn@anastas.io>,
        Steven Price <steven.price@arm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jens Axboe <axboe@kernel.dk>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Peter Xu <peterx@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Marco Elver <elver@google.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Nicolas Viennot <Nicolas.Viennot@twosigma.com>,
        Thomas Cedeno <thomascedeno@google.com>,
        Collin Fijalkovich <cfijalkovich@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Christian =?utf-8?Q?K=C3=B6nig?= 
        <ckoenig.leichtzumerken@gmail.com>, linux-unionfs@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>,
        "the arch\/x86 maintainers" <x86@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
References: <20210812084348.6521-1-david@redhat.com> <87o8a2d0wf.fsf@disp2133>
        <60db2e61-6b00-44fa-b718-e4361fcc238c@www.fastmail.com>
        <87lf56bllc.fsf@disp2133>
        <CAHk-=wgru1UAm3kAKSOdnbewPXQMOxYkq9PnAsRadAC6pXCCMQ@mail.gmail.com>
Date:   Thu, 12 Aug 2021 13:47:02 -0500
In-Reply-To: <CAHk-=wgru1UAm3kAKSOdnbewPXQMOxYkq9PnAsRadAC6pXCCMQ@mail.gmail.com>
        (Linus Torvalds's message of "Thu, 12 Aug 2021 08:10:28 -1000")
Message-ID: <87eeay8pqx.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mEFjx-00BaoL-09;;;mid=<87eeay8pqx.fsf@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/+xgQs/isxhAMff4xgeqSG4YWINDOzo/I=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v1 0/7] Remove in-tree usage of MAP_DENYWRITE
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Aug 12, 2021 at 7:48 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> Given that MAP_PRIVATE for shared libraries is our strategy for handling
>> writes to shared libraries perhaps we just need to use MAP_POPULATE or a
>> new related flag (perhaps MAP_PRIVATE_NOW)
>
> No. That would be horrible for the usual bloated GUI libraries. It
> might help some (dynamic page faults are not cheap either), but it
> would hurt a lot.

I wasn't aiming so much at the MAP_POPULATE part but something that
would trigger cow from writes to the file.  I see code that is close but
I don't see any code in the kernel that would implement that currently.

Upon reflection I think it will always be difficult to trigger cow from
the file write side of the kernel as code that would cow the page in
the page cache would cause problems with writable mmaps.

> This is definitely a "if you overwrite a system library while it's
> being used, you get to keep both pieces" situation.
>
> The kernel ETXTBUSY thing is purely a courtesy feature, and as people
> have noticed it only really works for the main executable because of
> various reasons. It's not something user space should even rely on,
> it's more of a "ok, you're doing something incredibly stupid, and
> we'll help you avoid shooting yourself in the foot when we notice".
>
> Any distro should make sure their upgrade tools don't just
> truncate/write to random libraries executables.

Yes.  I am trying to come up with advice on how userspace
implementations can implement their tools to use other mechanisms that
solve the overwriting shared libaries and executables problem that
are not broken by design.

For a little bit the way Florian Weirmer was talking and the fact that
uselib uses MAP_PRIVATE had me thinking that somehow MAP_PRIVATE could
be part of the solution.  I have now looked into the implementation of
MAP_PRIVATE and I since we don't perform the cow on filesystem writes
MAP_PRIVATE absolutely can not be part of the solution we recommend to
userspace.

So today the best advice I can give to userspace is to mark their
executables and shared libraries as read-only and immutable.  Otherwise
a change to the executable file can change what is mapped into memory.
MAP_PRIVATE does not help.

> And if they do, it's really not a kernel issue.

What is a kernel issue is giving people good advice on how to use kernel
features to solve real world problems.  I have seen the write to a
mapped exectuable/shared lib problem, and Florian has seen it.  So while
rare the problem is real and a pain to debug.

> This patch series basically takes this very historical error return,
> and simplifies and clarifies the implementation, and in the process
> might change some very subtle corner case (unmapping the original
> executable entirely?). I hope (and think) it wouldn't matter exactly
> because this is a "courtesy error" rather than anything that a sane
> setup would _depend_ on, but hey, insane setups clearly exist.

Oh yes.

I very much agree that the design of this patchset is perfectly fine.

I also see that MAP_DENYWRITE is unfortunately broken by design.  I
vaguely remember the discussion when MAP_DENYWRITE was made a noop
because of the denial-of-service aspect of MAP_DENYWRITE.

I very much agree that we should strongly encourage userspace not
to write to mmaped files.

As I am learning with my two year old, it helps to give a constructive
suggestion of alternative behavior instead of just saying no.
Florian reported that there remains a problem in userspace. So I am
coming up with a constructive suggestion.  My apologies for going off
into the weeds for a moment.

Eric

