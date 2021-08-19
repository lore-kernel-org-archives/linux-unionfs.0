Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C5AC4320A
	for <linux-unionfs@archiver.kernel.org>; Thu, 19 Aug 2021 22:33:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEE7B6109E
	for <linux-unionfs@archiver.kernel.org>; Thu, 19 Aug 2021 22:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236175AbhHSWdh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 19 Aug 2021 18:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235854AbhHSWdh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 19 Aug 2021 18:33:37 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6547BC061575
        for <linux-unionfs@vger.kernel.org>; Thu, 19 Aug 2021 15:33:00 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id e21so83627ejz.12
        for <linux-unionfs@vger.kernel.org>; Thu, 19 Aug 2021 15:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d7xFbb+3EvqQGpxyml4JHHWLdIJirfcFBHOQItDEp7E=;
        b=WJcRZ5ECnMTu5Q30pfx/0sVzarr1xcPILRNADM84n9O0Z5vxSCIEUyI67jzVtA2erg
         2u4KECFy2YAYP9QfFCE1KRjE+0ldOJD2qybITXQz3MnjYBy7U8BGR/S3O2zpZU3ODREn
         vt5dXowvmoFxXKfn8qNFotVfe953q+8cvuBsw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d7xFbb+3EvqQGpxyml4JHHWLdIJirfcFBHOQItDEp7E=;
        b=oxiU0RFbb9+WlEfiRWoOvMDo87UeR/bhlbJDwpJ4yQYrk5BKbwyI2bQjeKccsRPS21
         5mhq805VieY/HgTs2C2TD45dlcf8b6oGvlAikBeNp+x7s82LYPliyyd/jjB7T5Vv+XsO
         dA9Xuaqe+cQcwMxCEEVETCGQwGcJaxCV9wTtcV52Zr4pZyp3jZg6pOTvEOjytWMgHNiQ
         xqIwif/AWzWnOGAtuDdkd7SqIuQ5VvhpAvkoQxQtsHEhKc2pNq4Q1y55ZPhWcscVw7xl
         o86xkYF94awIwsnFgvexqM17UNaBU23uhUsxPoi0nTTn+ZCbF8kQwQBthDlM0rY4iD5O
         KlOA==
X-Gm-Message-State: AOAM532YIifRrSpVfhvNfYLei2pfigErpLiErgi3mm1atZc/wnxbl3wy
        zMhHk2zOd2bH0XVuJgYGfJwuDZJ4fBqt5AV7B2o=
X-Google-Smtp-Source: ABdhPJwFsef6QT5x59Azsu9VhWfsei1BpOAz4xh0faXNIrZVY/dSKkDYxm3nkmWVKUfuWCt9TG2K3Q==
X-Received: by 2002:a17:907:101a:: with SMTP id ox26mr18131457ejb.282.1629412379023;
        Thu, 19 Aug 2021 15:32:59 -0700 (PDT)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id q6sm1844381ejm.106.2021.08.19.15.32.58
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 15:32:58 -0700 (PDT)
Received: by mail-ed1-f53.google.com with SMTP id d6so11081119edt.7
        for <linux-unionfs@vger.kernel.org>; Thu, 19 Aug 2021 15:32:58 -0700 (PDT)
X-Received: by 2002:a2e:557:: with SMTP id 84mr13704523ljf.507.1629412367774;
 Thu, 19 Aug 2021 15:32:47 -0700 (PDT)
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
 <CAHk-=wgD-SNxB=2iCurEoP=RjrciRgLtXZ7R_DejK+mXF2etfg@mail.gmail.com> <639d90212662cf5cdf80c71bbfec95907c70114a.camel@kernel.org>
In-Reply-To: <639d90212662cf5cdf80c71bbfec95907c70114a.camel@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 19 Aug 2021 15:32:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgHbYmUZvFkthGJ6zZx+ofTiiTRxPai5mPkmbtE=6JbaQ@mail.gmail.com>
Message-ID: <CAHk-=wgHbYmUZvFkthGJ6zZx+ofTiiTRxPai5mPkmbtE=6JbaQ@mail.gmail.com>
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

On Thu, Aug 19, 2021 at 2:43 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> What sort of big, ugly warning did you have in mind?

I originally thought WARN_ON_ONCE() just to get the distro automatic
error handling involved, but it would probably be a big problem for
the people who end up having panic-on-warn or something.

So probably just a "make it a big box" thing that stands out, kind of
what lockdep etc does with

        pr_warn("======...====\n");

around the messages..

I don't know if distros have some pattern we could use that would end
up being something that gets reported to the user?

              Linus
