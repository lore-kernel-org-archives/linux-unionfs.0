Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2469EC4320A
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Aug 2021 17:49:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F05A260FED
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Aug 2021 17:49:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237006AbhHLRtq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 13:49:46 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:53048 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbhHLRtM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Aug 2021 13:49:12 -0400
Received: from in02.mta.xmission.com ([166.70.13.52]:56990)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mEEot-00CZrX-K4; Thu, 12 Aug 2021 11:48:43 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:43726 helo=email.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mEEor-00BSXH-NO; Thu, 12 Aug 2021 11:48:42 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     "Andy Lutomirski" <luto@kernel.org>
Cc:     "David Hildenbrand" <david@redhat.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        "Alexey Dobriyan" <adobriyan@gmail.com>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        "Peter Zijlstra \(Intel\)" <peterz@infradead.org>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Alexander Shishkin" <alexander.shishkin@linux.intel.com>,
        "Jiri Olsa" <jolsa@redhat.com>,
        "Namhyung Kim" <namhyung@kernel.org>,
        "Petr Mladek" <pmladek@suse.com>,
        "Sergey Senozhatsky" <sergey.senozhatsky@gmail.com>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        "Rasmus Villemoes" <linux@rasmusvillemoes.dk>,
        "Kees Cook" <keescook@chromium.org>,
        "Greg Ungerer" <gerg@linux-m68k.org>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "Mike Rapoport" <rppt@kernel.org>,
        "Vlastimil Babka" <vbabka@suse.cz>,
        "Vincenzo Frascino" <vincenzo.frascino@arm.com>,
        "Chinwen Chang" <chinwen.chang@mediatek.com>,
        "Michel Lespinasse" <walken@google.com>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
        "Huang Ying" <ying.huang@intel.com>,
        "Jann Horn" <jannh@google.com>, "Feng Tang" <feng.tang@intel.com>,
        "Kevin Brodsky" <Kevin.Brodsky@arm.com>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "Shawn Anastasio" <shawn@anastas.io>,
        "Steven Price" <steven.price@arm.com>,
        "Nicholas Piggin" <npiggin@gmail.com>,
        "Christian Brauner" <christian.brauner@ubuntu.com>,
        "Jens Axboe" <axboe@kernel.dk>,
        "Gabriel Krisman Bertazi" <krisman@collabora.com>,
        "Peter Xu" <peterx@redhat.com>,
        "Suren Baghdasaryan" <surenb@google.com>,
        "Shakeel Butt" <shakeelb@google.com>,
        "Marco Elver" <elver@google.com>,
        "Daniel Jordan" <daniel.m.jordan@oracle.com>,
        "Nicolas Viennot" <Nicolas.Viennot@twosigma.com>,
        "Thomas Cedeno" <thomascedeno@google.com>,
        "Collin Fijalkovich" <cfijalkovich@google.com>,
        "Michal Hocko" <mhocko@suse.com>,
        "Miklos Szeredi" <miklos@szeredi.hu>,
        "Chengguang Xu" <cgxu519@mykernel.net>,
        Christian =?utf-8?Q?K=C3=B6nig?= 
        <ckoenig.leichtzumerken@gmail.com>, linux-unionfs@vger.kernel.org,
        "Linux API" <linux-api@vger.kernel.org>,
        "the arch\/x86 maintainers" <x86@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20210812084348.6521-1-david@redhat.com> <87o8a2d0wf.fsf@disp2133>
        <60db2e61-6b00-44fa-b718-e4361fcc238c@www.fastmail.com>
Date:   Thu, 12 Aug 2021 12:48:31 -0500
In-Reply-To: <60db2e61-6b00-44fa-b718-e4361fcc238c@www.fastmail.com> (Andy
        Lutomirski's message of "Thu, 12 Aug 2021 10:35:18 -0700")
Message-ID: <87lf56bllc.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mEEor-00BSXH-NO;;;mid=<87lf56bllc.fsf@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/OvYtr6rpA2spNYcD/3k7B29elZOFJvvw=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v1 0/7] Remove in-tree usage of MAP_DENYWRITE
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

"Andy Lutomirski" <luto@kernel.org> writes:

> On Thu, Aug 12, 2021, at 10:32 AM, Eric W. Biederman wrote:
>> David Hildenbrand <david@redhat.com> writes:
>> 
>> > This series is based on v5.14-rc5 and corresponds code-wise to the
>> > previously sent RFC [1] (the RFC still applied cleanly).
>> >
>> > This series removes all in-tree usage of MAP_DENYWRITE from the kernel
>> > and removes VM_DENYWRITE. We stopped supporting MAP_DENYWRITE for
>> > user space applications a while ago because of the chance for DoS.
>> > The last renaming user is binfmt binary loading during exec and
>> > legacy library loading via uselib().
>> >
>> > With this change, MAP_DENYWRITE is effectively ignored throughout the
>> > kernel. Although the net change is small, I think the cleanup in mmap()
>> > is quite nice.
>> >
>> > There are some (minor) user-visible changes with this series:
>> > 1. We no longer deny write access to shared libaries loaded via legacy
>> >    uselib(); this behavior matches modern user space e.g., via dlopen().
>> > 2. We no longer deny write access to the elf interpreter after exec
>> >    completed, treating it just like shared libraries (which it often is).
>> > 3. We always deny write access to the file linked via /proc/pid/exe:
>> >    sys_prctl(PR_SET_MM_EXE_FILE) will fail if write access to the file
>> >    cannot be denied, and write access to the file will remain denied
>> >    until the link is effectivel gone (exec, termination,
>> >    PR_SET_MM_EXE_FILE) -- just as if exec'ing the file.
>> >
>> > I was wondering if we really care about permanently disabling write access
>> > to the executable, or if it would be good enough to just disable write
>> > access while loading the new executable during exec; but I don't know
>> > the history of that -- and it somewhat makes sense to deny write access
>> > at least to the main executable. With modern user space -- dlopen() -- we
>> > can effectively modify the content of shared libraries while being
>> > used.
>> 
>> So I think what we really want to do is to install executables with
>> and shared libraries without write permissions and immutable.  So that
>> upgrades/replacements of the libraries and executables are forced to
>> rename or unlink them.  We need the immutable bit as CAP_DAC_OVERRIDE
>> aka being root ignores the writable bits when a file is opened for
>> write.  However CAP_DAC_OVERRIDE does not override the immutable state
>> of a file.
>
> If we really want to do this, I think we'd want a different flag
> that's more like sealed.  Non-root users should be able to do this,
> too.
>
> Or we could just more gracefully handle users that overwrite running
> programs.

I had a blind spot, and Florian Weimer made a very reasonable request.
Apparently userspace for shared libraires uses MAP_PRIVATE.

So we almost don't care if the library is overwritten.  We loose some
efficiency and apparently there are some corner cases like the library
being extended past the end of the exiting file that are problematic.

Given that MAP_PRIVATE for shared libraries is our strategy for handling
writes to shared libraries perhaps we just need to use MAP_POPULATE or a
new related flag (perhaps MAP_PRIVATE_NOW) that just makes certain that
everything mapped from the executable is guaranteed to be visible from
the time of the mmap, and any changes from the filesystem side after
that are guaranteed to cause a copy on write.

Once we get that figured out we could consider getting rid of deny-write
entirely.

Eric
