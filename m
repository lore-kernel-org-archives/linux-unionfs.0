Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07D30C433EF
	for <linux-unionfs@archiver.kernel.org>; Sun,  5 Sep 2021 17:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB94B60F5B
	for <linux-unionfs@archiver.kernel.org>; Sun,  5 Sep 2021 17:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238057AbhIERTE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 5 Sep 2021 13:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238044AbhIERTA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 5 Sep 2021 13:19:00 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889FBC061757
        for <linux-unionfs@vger.kernel.org>; Sun,  5 Sep 2021 10:17:57 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id u14so8405311ejf.13
        for <linux-unionfs@vger.kernel.org>; Sun, 05 Sep 2021 10:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jpxSclMyPpq3hjTkndeLX+vXWq2jAp6AUp9RJSFInpc=;
        b=gK/q/jXjhkCQnjJcvu9HTWv3Xy/cZUkhrGXV+w6Yieir7RJN0wnXBCgrW7qEaTLfMe
         oYo31t90pvfHuligx33j3D0RxXp6Y2ZbKY0rpcBN0DvbvSQ1EHWrcrgoKint1hxYzqDA
         HGx76j07IWwevhOJYViS08kEj6stJNiezUr3E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jpxSclMyPpq3hjTkndeLX+vXWq2jAp6AUp9RJSFInpc=;
        b=U1hQbihTPQ0Indm+UqdcpQ2iKVgN6fABZnP0y8jeEJJXXkqjf9i9WHby9/JAAn+WLi
         X78Mz9csCrikSvHWyF93fAOXsRQKDly6FRGh0u1AJvW0QOFvBhmRihDkzr7A3cXsFf5b
         dmySXY59rhTjxOubR1N0XaC/RAr+H3O6fNNVPtFGYfpiGYcw6Tu/DSNPxsiML12d1jYM
         F2p2PfuYaXxEPhMfcqutovJr1oP9qVdwpV5i3+TxxHnKrhrR5GtXp0j+1/plyvOaKUZy
         RCGt9izpsmVtAuMJVVpqv+ulv6+B+Gg/XvVSGuKGw/LQfuAekeEU5ldTAo0w5/WFMJJo
         fJdw==
X-Gm-Message-State: AOAM531NW9l+SPRBTo2ckpWDrfK/I0p+SAV3RUwPCFRRR6OH32Wuhdag
        8lRJmVL/8aKs0kn4eFJ5EfGjOTVz57srabicHPk=
X-Google-Smtp-Source: ABdhPJxw2a6vvebq4iMC8a/TI1HnlJqr+6HiAn3dLbPJxygeLjvG+lEqcwk0OK2W4N08TJqUrf7s9w==
X-Received: by 2002:a17:907:92c:: with SMTP id au12mr9574530ejc.523.1630862274643;
        Sun, 05 Sep 2021 10:17:54 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id kk2sm2577291ejc.114.2021.09.05.10.17.53
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Sep 2021 10:17:54 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id h9so8463210ejs.4
        for <linux-unionfs@vger.kernel.org>; Sun, 05 Sep 2021 10:17:53 -0700 (PDT)
X-Received: by 2002:a2e:a7d0:: with SMTP id x16mr7195539ljp.494.1630862262563;
 Sun, 05 Sep 2021 10:17:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210816194840.42769-1-david@redhat.com> <20210816194840.42769-2-david@redhat.com>
 <20210905153229.GA3019909@roeck-us.net>
In-Reply-To: <20210905153229.GA3019909@roeck-us.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 5 Sep 2021 10:17:26 -0700
X-Gmail-Original-Message-ID: <CAHk-=whO-dnNxz5H8yfnGsNxrDHu-TVQq-X-VwhoDyWu3Lgnyg@mail.gmail.com>
Message-ID: <CAHk-=whO-dnNxz5H8yfnGsNxrDHu-TVQq-X-VwhoDyWu3Lgnyg@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] binfmt: don't use MAP_DENYWRITE when loading
 shared libraries via uselib()
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     David Hildenbrand <david@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mike Rapoport <rppt@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Chinwen Chang <chinwen.chang@mediatek.com>,
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
        Michal Hocko <mhocko@suse.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Chengguang Xu <cgxu519@mykernel.net>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <ckoenig.leichtzumerken@gmail.com>,
        Florian Weimer <fweimer@redhat.com>,
        David Laight <David.Laight@aculab.com>,
        linux-unionfs@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Sep 5, 2021 at 8:32 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> Guess someone didn't care compile testing their code. This is now in
> mainline.

To be fair, a.out is disabled pretty much on all relevant platforms these days.

Only alpha and m68k left, I think.

I applied the obvious patch from Geert.

            Linus
