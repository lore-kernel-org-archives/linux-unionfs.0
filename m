Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F365BC4320A
	for <linux-unionfs@archiver.kernel.org>; Fri, 20 Aug 2021 16:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D260761131
	for <linux-unionfs@archiver.kernel.org>; Fri, 20 Aug 2021 16:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhHTQNg (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 20 Aug 2021 12:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbhHTQNg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 20 Aug 2021 12:13:36 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A65C061756
        for <linux-unionfs@vger.kernel.org>; Fri, 20 Aug 2021 09:12:57 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id gt38so21147881ejc.13
        for <linux-unionfs@vger.kernel.org>; Fri, 20 Aug 2021 09:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mzTg/T5rxtdzoGmN3P0CSeW1UdQythyyKuVbkMYCPbE=;
        b=WdRAnbBbKD4NYNOEoU32NVSXl0xdyTdGAzo1g1eX67aWeryIYd/gjpKGX0OdMru+sw
         JAacMgCc8/geZAPcmxKQR+4SqL978WORH4bsJElSC/YM4T3uSCBvJGPsAmmgv823yaC+
         LOgcV3xCPibhMcvn6FEMtZuzLxr8aWxzaRpYw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mzTg/T5rxtdzoGmN3P0CSeW1UdQythyyKuVbkMYCPbE=;
        b=o9LrRgbTECNYS9LTSW53Vvk2012j7VVpBmQlyLlEI+RXqKq9jlqaexVvBAls7lUA+B
         9yvIlBV1Jvfm0t0s+pOTq9Vkc/a1XY5F3yYEuhn3kvR5cHtSQNJefTvgLpOMw1P1vztZ
         EK3nF7S9RkUFAf+5Vt5gBAka/rf7arvTflNMfNxU7s7q++9iCt2HNmk+2Wl1fY1I5Q3G
         yonFSZKNfUBI8yWSg5GqB6AoM843epb2+hC3HWgy9vK6SPzP+b/Vx8C22F72wTk4H5MQ
         RMTLAlgUSMi82vQjPmyeOqpYpGtjjrEjCK9AMo0mQqmGtXicES+LOhuyKhzUVIiRKNRB
         sfzw==
X-Gm-Message-State: AOAM530N/kQxQYYdcACQ6U/zDQk2liV1Bnf/QfDdfkpOp0nOBjGJT3Ug
        t/D9V3UJpvYcgoeUHKnABgw31Whg0s5mLzNINfg=
X-Google-Smtp-Source: ABdhPJwjAi6yOFZPq5g+yc56oAou7axNz22ePMBPE0VT5Syev3jVAKsPNIHVIqYa3UcNeXj8AKfKfA==
X-Received: by 2002:a17:906:6884:: with SMTP id n4mr22181196ejr.265.1629475976208;
        Fri, 20 Aug 2021 09:12:56 -0700 (PDT)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id f16sm3805512edw.79.2021.08.20.09.12.56
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 09:12:56 -0700 (PDT)
Received: by mail-ej1-f43.google.com with SMTP id z20so21236285ejf.5
        for <linux-unionfs@vger.kernel.org>; Fri, 20 Aug 2021 09:12:56 -0700 (PDT)
X-Received: by 2002:ac2:5a1a:: with SMTP id q26mr15105739lfn.41.1629475615982;
 Fri, 20 Aug 2021 09:06:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210812084348.6521-1-david@redhat.com> <87o8a2d0wf.fsf@disp2133>
 <60db2e61-6b00-44fa-b718-e4361fcc238c@www.fastmail.com> <87lf56bllc.fsf@disp2133>
 <CAHk-=wgru1UAm3kAKSOdnbewPXQMOxYkq9PnAsRadAC6pXCCMQ@mail.gmail.com>
 <87eeay8pqx.fsf@disp2133> <5b0d7c1e73ca43ef9ce6665fec6c4d7e@AcuMS.aculab.com>
 <87h7ft2j68.fsf@disp2133> <CAHk-=whmXTiGUzVrTP=mOPQrg-XOi3R-45hC4dQOqW4JmZdFUQ@mail.gmail.com>
 <b629cda1-becd-4725-b16c-13208ff478d3@www.fastmail.com> <YRcyqbpVqwwq3P6n@casper.infradead.org>
 <87k0kkxbjn.fsf_-_@disp2133> <0c2af732e4e9f74c9d20b09fc4b6cbae40351085.camel@kernel.org>
 <CAHk-=wgewmbABDC3_ZNn11C+sm4Uz0L9HZ5Kvx0Joho4vsV4DQ@mail.gmail.com>
 <a1385746582a675c410aca4eb4947320faec4821.camel@kernel.org>
 <CAHk-=wgD-SNxB=2iCurEoP=RjrciRgLtXZ7R_DejK+mXF2etfg@mail.gmail.com>
 <639d90212662cf5cdf80c71bbfec95907c70114a.camel@kernel.org>
 <CAHk-=wgHbYmUZvFkthGJ6zZx+ofTiiTRxPai5mPkmbtE=6JbaQ@mail.gmail.com> <20210820094301.62421e21@oasis.local.home>
In-Reply-To: <20210820094301.62421e21@oasis.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 20 Aug 2021 09:06:40 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi5xeN3fxfjqZu9HjhiMKfMJDeqniDU+S_ZigTG0uo3iA@mail.gmail.com>
Message-ID: <CAHk-=wi5xeN3fxfjqZu9HjhiMKfMJDeqniDU+S_ZigTG0uo3iA@mail.gmail.com>
Subject: Re: Removing Mandatory Locks
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jeff Layton <jlayton@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        David Laight <David.Laight@aculab.com>,
        David Hildenbrand <david@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
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
        "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "<linux-fsdevel@vger.kernel.org>" <linux-fsdevel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Florian Weimer <fweimer@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Aug 20, 2021 at 6:43 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 19 Aug 2021 15:32:31 -0700
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> > I don't know if distros have some pattern we could use that would end
> > up being something that gets reported to the user?
>
> People have started using my trace-printk notice message, that seems to
> be big enough to get noticed.

Well, I think people who use ftrace are m,ore likely to look at kernel
messages than most...

So what would be more interesting is if there's some distro support
for showing kernel notifications..

I see new notifications for calendar events, for devices that got
mounted, for a lot of things - so I'm really wondering if somebody
already perhaps had something for specially formatted kernel
messages..

               Linus
