Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECAEEC4338F
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Aug 2021 17:32:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7F1661019
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Aug 2021 17:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236024AbhHLRdO convert rfc822-to-8bit (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 13:33:14 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:49972 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235761AbhHLRdO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Aug 2021 13:33:14 -0400
Received: from in01.mta.xmission.com ([166.70.13.51]:46440)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mEEZP-00CYIS-Jm; Thu, 12 Aug 2021 11:32:44 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:43416 helo=email.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mEEZN-00F2lu-Ss; Thu, 12 Aug 2021 11:32:43 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
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
        linux-api@vger.kernel.org, x86@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20210812084348.6521-1-david@redhat.com>
Date:   Thu, 12 Aug 2021 12:32:32 -0500
In-Reply-To: <20210812084348.6521-1-david@redhat.com> (David Hildenbrand's
        message of "Thu, 12 Aug 2021 10:43:41 +0200")
Message-ID: <87o8a2d0wf.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=1mEEZN-00F2lu-Ss;;;mid=<87o8a2d0wf.fsf@disp2133>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19FI287iqwYMTwt6jRUCSjjYQLxeiHk7/Y=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v1 0/7] Remove in-tree usage of MAP_DENYWRITE
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

David Hildenbrand <david@redhat.com> writes:

> This series is based on v5.14-rc5 and corresponds code-wise to the
> previously sent RFC [1] (the RFC still applied cleanly).
>
> This series removes all in-tree usage of MAP_DENYWRITE from the kernel
> and removes VM_DENYWRITE. We stopped supporting MAP_DENYWRITE for
> user space applications a while ago because of the chance for DoS.
> The last renaming user is binfmt binary loading during exec and
> legacy library loading via uselib().
>
> With this change, MAP_DENYWRITE is effectively ignored throughout the
> kernel. Although the net change is small, I think the cleanup in mmap()
> is quite nice.
>
> There are some (minor) user-visible changes with this series:
> 1. We no longer deny write access to shared libaries loaded via legacy
>    uselib(); this behavior matches modern user space e.g., via dlopen().
> 2. We no longer deny write access to the elf interpreter after exec
>    completed, treating it just like shared libraries (which it often is).
> 3. We always deny write access to the file linked via /proc/pid/exe:
>    sys_prctl(PR_SET_MM_EXE_FILE) will fail if write access to the file
>    cannot be denied, and write access to the file will remain denied
>    until the link is effectivel gone (exec, termination,
>    PR_SET_MM_EXE_FILE) -- just as if exec'ing the file.
>
> I was wondering if we really care about permanently disabling write access
> to the executable, or if it would be good enough to just disable write
> access while loading the new executable during exec; but I don't know
> the history of that -- and it somewhat makes sense to deny write access
> at least to the main executable. With modern user space -- dlopen() -- we
> can effectively modify the content of shared libraries while being
> used.

So I think what we really want to do is to install executables with
and shared libraries without write permissions and immutable.  So that
upgrades/replacements of the libraries and executables are forced to
rename or unlink them.  We need the immutable bit as CAP_DAC_OVERRIDE
aka being root ignores the writable bits when a file is opened for
write.  However CAP_DAC_OVERRIDE does not override the immutable state
of a file.

I believe that denying write access at exec mmap time is actually much
to late in the process and making the denial of writing much larger in
scope is fundamentally what we want to do.  Changing how we install the
files, avoids the denial of service problems that MAP_DENYWRITE had.
Making the denial always happen ensures that installation programs are
never fooled into thinking a non-atomic update of an executable or
shared library is ok.

Still that is non-kernel work so I don't know who would make that
change.

As this fundamentally simplifies and a design mistake with very little
functional change.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

For the entire series.


> There is a related problem [2] with overlayfs, that should at least partly
> be tackled by this series. I don't quite understand the interaction of
> overlayfs and deny_write_access()/allow_write_access() at exec time:
>
> If we end up denying write access to the wrong file and not to the
> realfile, that would be fundamentally broken. We would have to reroute
> our deny_write_access()/ allow_write_access() calls for the exec file to
> the realfile -- but I leave figuring out the details to overlayfs guys, as
> that would be a related but different issue.
>
> RFC -> v1:
> - "binfmt: remove in-tree usage of MAP_DENYWRITE"
> -- Add a note that this should fix part of a problem with overlayfs
>
> [1] https://lore.kernel.org/r/20210423131640.20080-1-david@redhat.com/
> [2] https://lore.kernel.org/r/YNHXzBgzRrZu1MrD@miu.piliscsaba.redhat.com/
>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Greg Ungerer <gerg@linux-m68k.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
> Cc: Chinwen Chang <chinwen.chang@mediatek.com>
> Cc: Michel Lespinasse <walken@google.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Cc: Huang Ying <ying.huang@intel.com>
> Cc: Jann Horn <jannh@google.com>
> Cc: Feng Tang <feng.tang@intel.com>
> Cc: Kevin Brodsky <Kevin.Brodsky@arm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Shawn Anastasio <shawn@anastas.io>
> Cc: Steven Price <steven.price@arm.com>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Gabriel Krisman Bertazi <krisman@collabora.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Marco Elver <elver@google.com>
> Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
> Cc: Nicolas Viennot <Nicolas.Viennot@twosigma.com>
> Cc: Thomas Cedeno <thomascedeno@google.com>
> Cc: Collin Fijalkovich <cfijalkovich@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> Cc: Chengguang Xu <cgxu519@mykernel.net>
> Cc: "Christian König" <ckoenig.leichtzumerken@gmail.com>
> Cc: linux-unionfs@vger.kernel.org
> Cc: linux-api@vger.kernel.org
> Cc: x86@kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org
>
> David Hildenbrand (7):
>   binfmt: don't use MAP_DENYWRITE when loading shared libraries via
>     uselib()
>   kernel/fork: factor out atomcially replacing the current MM exe_file
>   kernel/fork: always deny write access to current MM exe_file
>   binfmt: remove in-tree usage of MAP_DENYWRITE
>   mm: remove VM_DENYWRITE
>   mm: ignore MAP_DENYWRITE in ksys_mmap_pgoff()
>   fs: update documentation of get_write_access() and friends
>
>  arch/x86/ia32/ia32_aout.c      |  8 ++--
>  fs/binfmt_aout.c               |  7 ++--
>  fs/binfmt_elf.c                |  6 +--
>  fs/binfmt_elf_fdpic.c          |  2 +-
>  fs/proc/task_mmu.c             |  1 -
>  include/linux/fs.h             | 19 +++++----
>  include/linux/mm.h             |  3 +-
>  include/linux/mman.h           |  4 +-
>  include/trace/events/mmflags.h |  1 -
>  kernel/events/core.c           |  2 -
>  kernel/fork.c                  | 75 ++++++++++++++++++++++++++++++----
>  kernel/sys.c                   | 33 +--------------
>  lib/test_printf.c              |  5 +--
>  mm/mmap.c                      | 29 ++-----------
>  mm/nommu.c                     |  2 -
>  15 files changed, 98 insertions(+), 99 deletions(-)
>
>
> base-commit: 36a21d51725af2ce0700c6ebcb6b9594aac658a6
