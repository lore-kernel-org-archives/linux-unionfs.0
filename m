Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D2E7C4320A
	for <linux-unionfs@archiver.kernel.org>; Sat, 14 Aug 2021 00:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6777561103
	for <linux-unionfs@archiver.kernel.org>; Sat, 14 Aug 2021 00:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235870AbhHNA7z (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 13 Aug 2021 20:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235989AbhHNA7y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 13 Aug 2021 20:59:54 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FE7C0617AD
        for <linux-unionfs@vger.kernel.org>; Fri, 13 Aug 2021 17:59:27 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id q3so13814073edt.5
        for <linux-unionfs@vger.kernel.org>; Fri, 13 Aug 2021 17:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aP8C3anb69IEcXZDXrtCZy8e7GufKV3iQMpFDR3MsUw=;
        b=VQ7qXsPM8mPwuVLcZ6b3R2xIGfiqrWY0GnB9MDJcTRHLdTUubq5dLZmZLaMUfW6Jaz
         3ZcwVaJi5Melx39QsAZljXuG0R3es9tDuhhezgS9h1QRR/qMPSsa2Ui4mdqLCDlpo9MF
         LZhw991Ce9fePNrB80rZFe+GjZ9Heu6gF8uhc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aP8C3anb69IEcXZDXrtCZy8e7GufKV3iQMpFDR3MsUw=;
        b=pOtHX/jWWztUTB+fM7MUbdb9PwWeI7wT6aU/VsknFH+BrhFIGDeJW1rH2zbTmzz46r
         Hx/VKArdTgW4ogyVUdZlT8zjQoYUX7zoxvV1f9uJWOGsti5uynCvSA9TpBr4cPa8IHsm
         BHVLMbQ+E72mldv3suzlQ8+pkP5MHuocvzISDDhmhW3W+5RiF0SMUA4K4KHo4W8hdko7
         PtUmBTbY7FKDhjdrn4xh2QAv0wN87FtBJ9WHMq6Okwk/5NHVJG0RxdIUa23ZaPB5LJQL
         A7Z6Th7Ouz4cD0BosRkkFUv6AjoPCtZYPky6atcmgbxfca/6DCNCqO2fW4JAWYHfk1zQ
         de8A==
X-Gm-Message-State: AOAM530bAhbLwLw5D9nvtds3BNzWYcB8HO3q75FxxtgrxjKiGqC4R7Lp
        sx/kxcQavg4xWEA4mhE1RFW3Ib0RfZNOhSkxZSU=
X-Google-Smtp-Source: ABdhPJx30A7yW3Lp4byhb30xueaNa/Hr+CJr2g736tHn/uT9s9yT+xEnzysgWGV+xFV9oeALGcehTw==
X-Received: by 2002:a05:6402:40c7:: with SMTP id z7mr6341322edb.193.1628902765519;
        Fri, 13 Aug 2021 17:59:25 -0700 (PDT)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com. [209.85.221.49])
        by smtp.gmail.com with ESMTPSA id r11sm1182517ejy.71.2021.08.13.17.59.24
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 17:59:25 -0700 (PDT)
Received: by mail-wr1-f49.google.com with SMTP id v4so8393894wro.12
        for <linux-unionfs@vger.kernel.org>; Fri, 13 Aug 2021 17:59:24 -0700 (PDT)
X-Received: by 2002:a2e:b703:: with SMTP id j3mr3764439ljo.220.1628902753618;
 Fri, 13 Aug 2021 17:59:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210812084348.6521-1-david@redhat.com> <87o8a2d0wf.fsf@disp2133>
 <60db2e61-6b00-44fa-b718-e4361fcc238c@www.fastmail.com> <87lf56bllc.fsf@disp2133>
 <CAHk-=wgru1UAm3kAKSOdnbewPXQMOxYkq9PnAsRadAC6pXCCMQ@mail.gmail.com>
 <87eeay8pqx.fsf@disp2133> <5b0d7c1e73ca43ef9ce6665fec6c4d7e@AcuMS.aculab.com>
 <87h7ft2j68.fsf@disp2133> <CAHk-=whmXTiGUzVrTP=mOPQrg-XOi3R-45hC4dQOqW4JmZdFUQ@mail.gmail.com>
 <b629cda1-becd-4725-b16c-13208ff478d3@www.fastmail.com> <CAHk-=wiJ0u33h2CXAO4b271Diik=z4jRt64=Gt6YV2jV4ef27g@mail.gmail.com>
In-Reply-To: <CAHk-=wiJ0u33h2CXAO4b271Diik=z4jRt64=Gt6YV2jV4ef27g@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 13 Aug 2021 14:58:57 -1000
X-Gmail-Original-Message-ID: <CAHk-=wgi2+OSk2_uYwhL56NGzN8t2To8hm+c0BdBEbuBuzhg6g@mail.gmail.com>
Message-ID: <CAHk-=wgi2+OSk2_uYwhL56NGzN8t2To8hm+c0BdBEbuBuzhg6g@mail.gmail.com>
Subject: Re: [PATCH v1 0/7] Remove in-tree usage of MAP_DENYWRITE
To:     Andy Lutomirski <luto@kernel.org>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        David Laight <David.Laight@aculab.com>,
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

On Fri, Aug 13, 2021 at 2:54 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And nobody really complained when we weakened it, so maybe removing it
> entirely might be acceptable.

I guess we could just try it and see... Worst comes to worst, we'll
have to put it back, but at least we'd know what crazy thing still
wants it..

              Linus
