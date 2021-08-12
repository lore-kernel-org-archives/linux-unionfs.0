Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05BBBC432BE
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Aug 2021 18:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4BCF6104F
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Aug 2021 18:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234244AbhHLSWR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 14:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbhHLSWR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Aug 2021 14:22:17 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ACDEC061756
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Aug 2021 11:21:51 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id n12so11064616edx.8
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Aug 2021 11:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IkXJUR2wo/lfdijzxf9i2+gB15K2x3AMKk03NvuHrAg=;
        b=DgletMF3GIx03R+Prc+kYYByk45jic0DRscnKADZUoHI1P+YyPtvtoPTQ7QnJ7IPQd
         SXOSwOUdkx2aiZaMFMOp1dhadasdgIRxU7GtFMCT7AGdEYsSqpb/znDsiIrZCbOQNfg4
         VzUm5rt2KFFchQnCpyiuGLbfU1kLNH4SQV4x0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IkXJUR2wo/lfdijzxf9i2+gB15K2x3AMKk03NvuHrAg=;
        b=JOtpni9Z3Oj8W9UxMz6KbAMhUUqoaDeLjVeSycGa+7dy3WQbF1S3SUcLtn1p+mACe7
         bV7YpCdTauiwf4XK5QhQRV7N5HYGYVzbf5AOW4qO4FOY9eK55aBAuhXXfYWEAEf8OoQD
         MlUGIX7WAT4Doct2yjnpMfk1Pw0RvO/qPw3QDfQHc2ixbtMbJ9xC0/m3EOE8KxuffNec
         Mivt1FGCSZOmD6JHFDQEluI91bMPNuKoJ2Sz1ScwJ5mBbwm/iWtWi9oSykYB97i4tGRp
         fJCQVd/ICE/16ahxZg0vqYuGbTP8acfF8ZjGICXtNcCqutMqkXSxgZIyad8Op2gHiBKG
         IGRQ==
X-Gm-Message-State: AOAM530bBhKHAmnSgjZPxpjgnk9Y3/Gc0A4H4XYGGKHbhYO+ighX6/8F
        4AG7JI6YUmMFARMkGE1VNGGC9HTd9HnuD0JagVE=
X-Google-Smtp-Source: ABdhPJxtuGjVkZN/hDN6D6t3dWgZx4D82Kk5BmkjBRUWy1fwxYgNt3JgGEIuzbd4cdAao4bIt8pN5Q==
X-Received: by 2002:a50:9b03:: with SMTP id o3mr6937215edi.203.1628792509537;
        Thu, 12 Aug 2021 11:21:49 -0700 (PDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id d2sm1109363ejo.13.2021.08.12.11.21.47
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 11:21:49 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id h13so9589782wrp.1
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Aug 2021 11:21:47 -0700 (PDT)
X-Received: by 2002:a2e:944c:: with SMTP id o12mr3785844ljh.411.1628792497006;
 Thu, 12 Aug 2021 11:21:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210812084348.6521-1-david@redhat.com> <87o8a2d0wf.fsf@disp2133>
 <60db2e61-6b00-44fa-b718-e4361fcc238c@www.fastmail.com> <87lf56bllc.fsf@disp2133>
 <87lf56edgz.fsf@oldenburg.str.redhat.com>
In-Reply-To: <87lf56edgz.fsf@oldenburg.str.redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 12 Aug 2021 08:21:20 -1000
X-Gmail-Original-Message-ID: <CAHk-=wifW=eDZdOdydRTmupzzJj=6A+Z5dLFrjM3Hfmxj6DfyA@mail.gmail.com>
Message-ID: <CAHk-=wifW=eDZdOdydRTmupzzJj=6A+Z5dLFrjM3Hfmxj6DfyA@mail.gmail.com>
Subject: Re: [PATCH v1 0/7] Remove in-tree usage of MAP_DENYWRITE
To:     Florian Weimer <fweimer@redhat.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@kernel.org>,
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

On Thu, Aug 12, 2021 at 8:16 AM Florian Weimer <fweimer@redhat.com> wrote:
>
> I think this is called MAP_COPY:
>
>   <https://www.gnu.org/software/hurd/glibc/mmap.html>

Please don't even consider the crazy notions that GNU Hurd did.

It's a fundamental design mistake. The Hurd VM was horrendous, and
MAP_COPY was a prime example of the kinds of horrors it had.

I'm not sure how much of the mis-designs were due to Hurd, and how
much of it due to Mach 3. But please don't point to Hurd VM
documentation except possibly to warn people. We want people to
_forget_ those mistakes, not repeat them.

          Linus
