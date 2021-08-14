Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE33FC4320A
	for <linux-unionfs@archiver.kernel.org>; Sat, 14 Aug 2021 00:55:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 922D56109D
	for <linux-unionfs@archiver.kernel.org>; Sat, 14 Aug 2021 00:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235989AbhHNAzm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 13 Aug 2021 20:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235870AbhHNAzl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 13 Aug 2021 20:55:41 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5712C061756
        for <linux-unionfs@vger.kernel.org>; Fri, 13 Aug 2021 17:55:13 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id z20so21420716ejf.5
        for <linux-unionfs@vger.kernel.org>; Fri, 13 Aug 2021 17:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xExJpARMLMkrq8sMXVZNiU6Vj9o2jrh13qRTaWd9c2s=;
        b=Sqr8VKtXgD581Tr4kn0EKrE7Z4POJhc426hpxltKuo89M4OxOeAqlheILSJpT3dpYb
         q26BxI3Tvc6AA/uqWqN0TqwJYd9SWTrC6FI7jk168E6pkyeUJGRl1snaKAfr4Foeaya2
         LoZc61X3CPgeQHcVM2mnCJvkbddQu0jakBCug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xExJpARMLMkrq8sMXVZNiU6Vj9o2jrh13qRTaWd9c2s=;
        b=aZMsymv0b2IVttNwtFLmr2aQE8nTDAmZ1oI8za81aT2RDF6LxzXuE9qQ6kKRdgfp+A
         lnOMeqNsO3iKr/EenIRX69zp/AxmuL3sn9sMBVt/hxhx+266Hv1BV6rO0snxGy29KAmZ
         oO2zfMfKiPiJml0s+XW9l01zdfFYqNBbTZvK6o5guHjYQrOg8k7CCkQI/g3bx3QNlStF
         nRxr06FuDjB26lDdFh0x7Dv3lx/cDEVpMkzpnA6efJVDaAoh/GPbdZnpaC/ih9KJ3T0F
         SPKVXhQyOwC+0f4H7k8VJmGVhMIejOiWH61aCbnRNtEU6f5iopD9Ch554vU7CLNhUkAp
         EqFw==
X-Gm-Message-State: AOAM532nN+70eVIgPOZGpdPxCEVYibjGHG6lAAS4O/Giv56E9KxPTAPz
        5vF5uP09leQ7TpG9gwZQF5YoAAc8NjT7tJn9kos=
X-Google-Smtp-Source: ABdhPJxrGkiMnk+Cg/xMrpUXIZwsJyG+Vs0ySJqv5qVvKhh4pqOu7ee3KIYKGS/FkuPy/cNMlfCeIw==
X-Received: by 2002:a17:906:584:: with SMTP id 4mr5336732ejn.56.1628902512282;
        Fri, 13 Aug 2021 17:55:12 -0700 (PDT)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id i11sm1548963edu.97.2021.08.13.17.55.10
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 17:55:11 -0700 (PDT)
Received: by mail-wr1-f41.google.com with SMTP id q11so15487539wrr.9
        for <linux-unionfs@vger.kernel.org>; Fri, 13 Aug 2021 17:55:10 -0700 (PDT)
X-Received: by 2002:a2e:81c2:: with SMTP id s2mr3500799ljg.48.1628902499779;
 Fri, 13 Aug 2021 17:54:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210812084348.6521-1-david@redhat.com> <87o8a2d0wf.fsf@disp2133>
 <60db2e61-6b00-44fa-b718-e4361fcc238c@www.fastmail.com> <87lf56bllc.fsf@disp2133>
 <CAHk-=wgru1UAm3kAKSOdnbewPXQMOxYkq9PnAsRadAC6pXCCMQ@mail.gmail.com>
 <87eeay8pqx.fsf@disp2133> <5b0d7c1e73ca43ef9ce6665fec6c4d7e@AcuMS.aculab.com>
 <87h7ft2j68.fsf@disp2133> <CAHk-=whmXTiGUzVrTP=mOPQrg-XOi3R-45hC4dQOqW4JmZdFUQ@mail.gmail.com>
 <b629cda1-becd-4725-b16c-13208ff478d3@www.fastmail.com>
In-Reply-To: <b629cda1-becd-4725-b16c-13208ff478d3@www.fastmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 13 Aug 2021 14:54:43 -1000
X-Gmail-Original-Message-ID: <CAHk-=wiJ0u33h2CXAO4b271Diik=z4jRt64=Gt6YV2jV4ef27g@mail.gmail.com>
Message-ID: <CAHk-=wiJ0u33h2CXAO4b271Diik=z4jRt64=Gt6YV2jV4ef27g@mail.gmail.com>
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
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Aug 13, 2021 at 2:49 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> I=E2=80=99ll bite.  How about we attack this in the opposite direction: r=
emove the deny write mechanism entirely.

I think that would be ok, except I can see somebody relying on it.

It's broken, it's stupid, but we've done that ETXTBUSY for a _loong_ time.

But you are right that we have removed parts of it over time (no more
MAP_DENYWRITE, no more uselib()) so that what we have today is a
fairly weak form of what we used to do.

And nobody really complained when we weakened it, so maybe removing it
entirely might be acceptable.

              Linus
