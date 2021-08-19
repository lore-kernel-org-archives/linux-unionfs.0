Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FEB1C4338F
	for <linux-unionfs@archiver.kernel.org>; Thu, 19 Aug 2021 19:21:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFC0A60F39
	for <linux-unionfs@archiver.kernel.org>; Thu, 19 Aug 2021 19:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbhHSTWZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 19 Aug 2021 15:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbhHSTWZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 19 Aug 2021 15:22:25 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994E7C061575
        for <linux-unionfs@vger.kernel.org>; Thu, 19 Aug 2021 12:21:48 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id gr13so15034136ejb.6
        for <linux-unionfs@vger.kernel.org>; Thu, 19 Aug 2021 12:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3vr2D0SIS0akc317M8AmB5tdttHbmb/GSWHt0r9JCvY=;
        b=Fi8Vc+JQZqNTkTyv3PJfMFM6Rl3+unfpZvxu37FIdnrCAKsddyUIQiihvHMsIlXmmG
         jNbLyQr3wk60i2yKJAYhtkAeCvXwf1kN2XLuYSaEIndqSsXppyqYoBHCIJS+KCfm+Uht
         PTLXKfh+AnNuqTz97gUxnmE0uYiHymupjQB9U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3vr2D0SIS0akc317M8AmB5tdttHbmb/GSWHt0r9JCvY=;
        b=SbF3QhNGQirmEr0Bi4LC7e/c5BK/sSZbQxLYanMJfT3LletHCzGt6Yywl5AyKjmD2Q
         shsstDN9i1nASbwuSOwWlRTnx53jMLs6ITtyra3qOCpwEctX7Bo0VF0WwwYSmYMa/mGX
         1lvz/0YDjr/h6eO4HigzvYPDvISXnarRX1MGsOYcud7BsntwuGHkgToN+2jIN4XG04VZ
         MvaIHnlNS8ZS3ky7ykn7o383YSg6jhUxWG2MX7xLYpgxmAmfh02y+HKmHa2FYA1Orcc2
         8fNdVOK0sMOlqjjMXBClhH+J+SteJIrbc9YYPRwgJZuMoMFQ0p22v5byrs5yjSn/VpUm
         bVQA==
X-Gm-Message-State: AOAM533kBvpK+OFGLeqnLbb7YuFsMNh8Tu4mDjNyvqGCmrOUSZGSfIc0
        jDKFVltuZ1BBNjTAJyqNLp3IX1TETTdB3jGjHz0=
X-Google-Smtp-Source: ABdhPJy6q/pdHETMXjSBHiZ+ef7fqtp5YJ+tL2vMISUHqGSRkccGZJdURAlbvpcFqT2vRdoIbwVE8Q==
X-Received: by 2002:a17:906:bc81:: with SMTP id lv1mr17193395ejb.393.1629400907094;
        Thu, 19 Aug 2021 12:21:47 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id g9sm1674866ejo.60.2021.08.19.12.21.46
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 12:21:46 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id bq25so14963072ejb.11
        for <linux-unionfs@vger.kernel.org>; Thu, 19 Aug 2021 12:21:46 -0700 (PDT)
X-Received: by 2002:a19:4f1a:: with SMTP id d26mr11307760lfb.377.1629400524676;
 Thu, 19 Aug 2021 12:15:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210812084348.6521-1-david@redhat.com> <87o8a2d0wf.fsf@disp2133>
 <60db2e61-6b00-44fa-b718-e4361fcc238c@www.fastmail.com> <87lf56bllc.fsf@disp2133>
 <CAHk-=wgru1UAm3kAKSOdnbewPXQMOxYkq9PnAsRadAC6pXCCMQ@mail.gmail.com>
 <87eeay8pqx.fsf@disp2133> <5b0d7c1e73ca43ef9ce6665fec6c4d7e@AcuMS.aculab.com>
 <87h7ft2j68.fsf@disp2133> <CAHk-=whmXTiGUzVrTP=mOPQrg-XOi3R-45hC4dQOqW4JmZdFUQ@mail.gmail.com>
 <b629cda1-becd-4725-b16c-13208ff478d3@www.fastmail.com> <YRcyqbpVqwwq3P6n@casper.infradead.org>
 <87k0kkxbjn.fsf_-_@disp2133> <0c2af732e4e9f74c9d20b09fc4b6cbae40351085.camel@kernel.org>
In-Reply-To: <0c2af732e4e9f74c9d20b09fc4b6cbae40351085.camel@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 19 Aug 2021 12:15:08 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgewmbABDC3_ZNn11C+sm4Uz0L9HZ5Kvx0Joho4vsV4DQ@mail.gmail.com>
Message-ID: <CAHk-=wgewmbABDC3_ZNn11C+sm4Uz0L9HZ5Kvx0Joho4vsV4DQ@mail.gmail.com>
Subject: Re: Removing Mandatory Locks
To:     Jeff Layton <jlayton@kernel.org>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
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

On Thu, Aug 19, 2021 at 11:39 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> I'm all for ripping it out too. It's an insane interface anyway.
>
> I've not heard a single complaint about this being turned off in
> fedora/rhel or any other distro that has this disabled.

I'd love to remove it, we could absolutely test it. The fact that
several major distros have it disabled makes me think it's fine.

But as always, it would be good to check Android.

The desktop distros tend to have the same tools and programs, so if
Fedora and RHEL haven't needed it for years, then it's likely stale in
Debian too (despite being enabled).

But Android tends to be very different. Does anybody know?

            Linus
