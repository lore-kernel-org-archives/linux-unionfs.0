Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 594D9C4320A
	for <linux-unionfs@archiver.kernel.org>; Fri, 20 Aug 2021 16:30:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E44C6113D
	for <linux-unionfs@archiver.kernel.org>; Fri, 20 Aug 2021 16:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbhHTQbM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 20 Aug 2021 12:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbhHTQbL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 20 Aug 2021 12:31:11 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5D6C06175F
        for <linux-unionfs@vger.kernel.org>; Fri, 20 Aug 2021 09:30:33 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id n18so9690001pgm.12
        for <linux-unionfs@vger.kernel.org>; Fri, 20 Aug 2021 09:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hx/7x/JErQYdtBSrXWm/zLl3le+VQc9WWGW/gattMeA=;
        b=AHhWe/b1QJudaK4piB/jpm81AVtQQUsE+FQy6FY3gPQsXxurQppN29+lwRB1w87Hk9
         s5LnDo+Sqxo/2pCK/R5LdbAN1tgOMvgop4IKUrmYIGWWy9GZBoPvfMqYDTrPjGlW+5pa
         Zl5yoXP7YgbsHkiiQ3CQ7BLFzXLsUcMFh1zuU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hx/7x/JErQYdtBSrXWm/zLl3le+VQc9WWGW/gattMeA=;
        b=s2vkLiyzHLr8ARyqvYMpAwKZkcWGqo27v0a8Zm8bxSViyyilYF8LHeQ9v1ViXHMJ5B
         TkPnQB071NTg6J1O+0C/0P/IRFotTbwWkeoD0LEKfsnsLUGdH+izyIyXiHGPP7fvvDgE
         r5DYH+pJgJJN/vQmKwhMTsMz64+dS8Kzv9W85DLIBndenqk3oOLL8p9BoBPlthAdWBG9
         oaF+VkWU52tFDTezaod2zTP5KAGD0oMA+faCzw0kHyNf4G0U4Y+s2OnU64DGuK3Aew2q
         y5UH/Pwsn/gCa6MvyVHfSOlq6Yis4ylCNbFPN4bGVwB0pk49u5ZcNjpjrJ1krDEM4GsW
         viAQ==
X-Gm-Message-State: AOAM533AXK/hSYEPjxPM1lK63whlX45BSj3niQx4XcIdQjby4bGYYPCa
        gvcs4BQAHqybk3nE5qdoDApgbw==
X-Google-Smtp-Source: ABdhPJwaxnuALu+UM0AoVLj6IiQMA+NoS7/1nkP1/GdVgN0I1V5xyMU8srw+/7RYQUxQMtn9M0uIlg==
X-Received: by 2002:a65:608f:: with SMTP id t15mr19281560pgu.452.1629477033146;
        Fri, 20 Aug 2021 09:30:33 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b7sm7023269pfl.195.2021.08.20.09.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 09:30:32 -0700 (PDT)
Date:   Fri, 20 Aug 2021 09:30:31 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
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
        Christian =?iso-8859-1?Q?K=F6nig?= 
        <ckoenig.leichtzumerken@gmail.com>,
        "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "<linux-fsdevel@vger.kernel.org>" <linux-fsdevel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Florian Weimer <fweimer@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: Removing Mandatory Locks
Message-ID: <202108200905.BE8AF7C@keescook>
References: <CAHk-=wgru1UAm3kAKSOdnbewPXQMOxYkq9PnAsRadAC6pXCCMQ@mail.gmail.com>
 <87eeay8pqx.fsf@disp2133>
 <5b0d7c1e73ca43ef9ce6665fec6c4d7e@AcuMS.aculab.com>
 <87h7ft2j68.fsf@disp2133>
 <CAHk-=whmXTiGUzVrTP=mOPQrg-XOi3R-45hC4dQOqW4JmZdFUQ@mail.gmail.com>
 <b629cda1-becd-4725-b16c-13208ff478d3@www.fastmail.com>
 <YRcyqbpVqwwq3P6n@casper.infradead.org>
 <87k0kkxbjn.fsf_-_@disp2133>
 <0c2af732e4e9f74c9d20b09fc4b6cbae40351085.camel@kernel.org>
 <CAHk-=wgewmbABDC3_ZNn11C+sm4Uz0L9HZ5Kvx0Joho4vsV4DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgewmbABDC3_ZNn11C+sm4Uz0L9HZ5Kvx0Joho4vsV4DQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Aug 19, 2021 at 12:15:08PM -0700, Linus Torvalds wrote:
> On Thu, Aug 19, 2021 at 11:39 AM Jeff Layton <jlayton@kernel.org> wrote:
> >
> > I'm all for ripping it out too. It's an insane interface anyway.
> >
> > I've not heard a single complaint about this being turned off in
> > fedora/rhel or any other distro that has this disabled.
> 
> I'd love to remove it, we could absolutely test it. The fact that
> several major distros have it disabled makes me think it's fine.

FWIW, it is now disabled in Ubuntu too:

https://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/linux/+git/impish/commit/?h=master-next&id=f3aac5e47789cbeb3177a14d3d2a06575249e14b

> But as always, it would be good to check Android.

It looks like it's enabled (checking the Pixel 4 kernel image), but it's
not specifically mentioned in any of the build configs that are used to
construct the image, so I think this is just catching the "default y". I
expect it'd be fine to turn this off.

I will ask around to see if it's actually used.

-- 
Kees Cook
