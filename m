Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 303B8C4338F
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Aug 2021 16:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10EEA60C40
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Aug 2021 16:18:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhHLQSx (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 12:18:53 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:34132 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhHLQSx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Aug 2021 12:18:53 -0400
Received: from in01.mta.xmission.com ([166.70.13.51]:43426)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mEDPR-00CQHg-B6; Thu, 12 Aug 2021 10:18:21 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:42228 helo=email.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mEDPQ-00EqWu-5G; Thu, 12 Aug 2021 10:18:20 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Florian Weimer <fweimer@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
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
        <87r1eyg8h6.fsf@oldenburg.str.redhat.com>
Date:   Thu, 12 Aug 2021 11:17:24 -0500
In-Reply-To: <87r1eyg8h6.fsf@oldenburg.str.redhat.com> (Florian Weimer's
        message of "Thu, 12 Aug 2021 14:20:37 +0200")
Message-ID: <877dgqfxij.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mEDPQ-00EqWu-5G;;;mid=<877dgqfxij.fsf@disp2133>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+fUaUYby0ovoa4j4axcDNjRQxbnPUhyZI=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v1 0/7] Remove in-tree usage of MAP_DENYWRITE
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Florian Weimer <fweimer@redhat.com> writes:

> * David Hildenbrand:
>
>> There are some (minor) user-visible changes with this series:
>> 1. We no longer deny write access to shared libaries loaded via legacy
>>    uselib(); this behavior matches modern user space e.g., via dlopen().
>> 2. We no longer deny write access to the elf interpreter after exec
>>    completed, treating it just like shared libraries (which it often is).
>
> We have a persistent issue with people using cp (or similar tools) to
> replace system libraries.  Since the file is truncated first, all
> relocations and global data are replaced by file contents, result in
> difficult-to-diagnose crashes.  It would be nice if we had a way to
> prevent this mistake.  It doesn't have to be MAP_DENYWRITE or MAP_COPY.
> It could be something completely new, like an option that turns every
> future access beyond the truncation point into a signal (rather than
> getting bad data or bad code and crashing much later).
>
> I don't know how many invalid copy operations are currently thwarted by
> the current program interpreter restriction.  I doubt that lifting the
> restriction matters.

I suspect that what should happen is that we should make shared
libraries and executables read-only on disk.

We could potentially take this a step farther and introduce a new sysctl
that causes "mmap(adr, len, PROT_EXEC, MAP_SHARED, fd, off)" but not
PROT_WRITE to fail if the file can be written by anyone.  That sysctl
could even deny chown adding write access to the file if there are
mappings open.

Given that there hasn't been enough pain for people to install shared
libraries read-only yet I suspect just installing executables and shared
libraries without write-permissions on disk is enough to prevent the
hard to track down bugs you have been talking about.

>> 3. We always deny write access to the file linked via /proc/pid/exe:
>>    sys_prctl(PR_SET_MM_EXE_FILE) will fail if write access to the file
>>    cannot be denied, and write access to the file will remain denied
>>    until the link is effectivel gone (exec, termination,
>>    PR_SET_MM_EXE_FILE) -- just as if exec'ing the file.
>>
>> I was wondering if we really care about permanently disabling write access
>> to the executable, or if it would be good enough to just disable write
>> access while loading the new executable during exec; but I don't know
>> the history of that -- and it somewhat makes sense to deny write access
>> at least to the main executable. With modern user space -- dlopen() -- we
>> can effectively modify the content of shared libraries while being used.
>
> Is there a difference between ET_DYN and ET_EXEC executables?

What is being changed is how we track which files to denying write
access on.  Instead of denying write-access based on a per mapping (aka
mmap) basis, the new code is only denying access to /proc/self/exe.

Because the method of tracking is much coarser is why the interper stops
being protected.  The code doesn't care how the mappings happen, only
if the file is /proc/self/exe or not.

Eric

