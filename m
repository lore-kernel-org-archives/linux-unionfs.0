Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EF35C4320A
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Aug 2021 18:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F31360FED
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Aug 2021 18:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237469AbhHLSL1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 14:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237366AbhHLSL0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Aug 2021 14:11:26 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3193C061756
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Aug 2021 11:11:00 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id x14so10988984edr.12
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Aug 2021 11:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kMjoLlvtmb7mlrSdQknNJvuiNoe+cD5cNxWCgcmURzw=;
        b=fAel4ZlqluiDbK7XT2TN285OpKL/k74SaHM+ukhLXBOh8aUgDoAGzVcLvAOBNcLwL7
         LW/VCMiZKL3GYhssOvLPpOPnx2NT/Qr4lb/26QY9QP4lDZrSUO3zX9NqiJlhGgoC6/lS
         /Ep9k9BaQCUABA+deLmcEAO5Iol8v4ErYRRpM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kMjoLlvtmb7mlrSdQknNJvuiNoe+cD5cNxWCgcmURzw=;
        b=eIDi5brib3QBRfyiOI990CRfPeWlIYLOBA/1+1NKJIk+/zGpE83EGsn7efkqLT4se3
         JYqXS5O1uJdOnsXUUZMLxVwdK40C/hvJtYey1fZfkWWNkhGQqnolRZgkBUcu3tCHbhKY
         /Hu7a15RT1gA+XAE78DNNGxd7DftppqNFxMK+43LAV/WVQFErjsfoJIZ+QtLX7ODzKPe
         j/kq+hpIvGMAU1WB9xycdErXUuSBk0wN0xOZ65GIl6joumVCrGuYTnpw4C35GCmQeuCe
         Jk8rPfLOrUOZne0oPtyXZ8dELZaWhwbaZBUg4o7ZwsZjX22yMMhpMLl24f78IFpgaUy2
         U1zg==
X-Gm-Message-State: AOAM531L1Jt/8IAIjwwxfAxjn7u1APoavDgD5redFk4iMf5diBBe0MNI
        yqpY+j/5bAfRne9A+SGyRqXbMcO8WjliGAJ65D4=
X-Google-Smtp-Source: ABdhPJyAd000UJNNmVc9NC69B1zQD7X75HpOhfLnorjK1dHwFavAjxwFM7TnJSzFMVYhPtg35/gFBA==
X-Received: by 2002:aa7:cb0f:: with SMTP id s15mr7135614edt.190.1628791858890;
        Thu, 12 Aug 2021 11:10:58 -0700 (PDT)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id a25sm1092621ejv.91.2021.08.12.11.10.55
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 11:10:56 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id hs10so13351289ejc.0
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Aug 2021 11:10:55 -0700 (PDT)
X-Received: by 2002:a05:6512:2091:: with SMTP id t17mr3426901lfr.253.1628791844375;
 Thu, 12 Aug 2021 11:10:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210812084348.6521-1-david@redhat.com> <87o8a2d0wf.fsf@disp2133>
 <60db2e61-6b00-44fa-b718-e4361fcc238c@www.fastmail.com> <87lf56bllc.fsf@disp2133>
In-Reply-To: <87lf56bllc.fsf@disp2133>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 12 Aug 2021 08:10:28 -1000
X-Gmail-Original-Message-ID: <CAHk-=wgru1UAm3kAKSOdnbewPXQMOxYkq9PnAsRadAC6pXCCMQ@mail.gmail.com>
Message-ID: <CAHk-=wgru1UAm3kAKSOdnbewPXQMOxYkq9PnAsRadAC6pXCCMQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/7] Remove in-tree usage of MAP_DENYWRITE
To:     "Eric W. Biederman" <ebiederm@xmission.com>
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
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
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
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
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
        =?UTF-8?Q?Christian_K=C3=B6nig?= <ckoenig.leichtzumerken@gmail.com>,
        linux-unionfs@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Aug 12, 2021 at 7:48 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Given that MAP_PRIVATE for shared libraries is our strategy for handling
> writes to shared libraries perhaps we just need to use MAP_POPULATE or a
> new related flag (perhaps MAP_PRIVATE_NOW)

No. That would be horrible for the usual bloated GUI libraries. It
might help some (dynamic page faults are not cheap either), but it
would hurt a lot.

This is definitely a "if you overwrite a system library while it's
being used, you get to keep both pieces" situation.

The kernel ETXTBUSY thing is purely a courtesy feature, and as people
have noticed it only really works for the main executable because of
various reasons. It's not something user space should even rely on,
it's more of a "ok, you're doing something incredibly stupid, and
we'll help you avoid shooting yourself in the foot when we notice".

Any distro should make sure their upgrade tools don't just
truncate/write to random libraries executables.

And if they do, it's really not a kernel issue.

This patch series basically takes this very historical error return,
and simplifies and clarifies the implementation, and in the process
might change some very subtle corner case (unmapping the original
executable entirely?). I hope (and think) it wouldn't matter exactly
because this is a "courtesy error" rather than anything that a sane
setup would _depend_ on, but hey, insane setups clearly exist.

               Linus
