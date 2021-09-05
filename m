Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A4D7C433F5
	for <linux-unionfs@archiver.kernel.org>; Sun,  5 Sep 2021 19:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A8C560234
	for <linux-unionfs@archiver.kernel.org>; Sun,  5 Sep 2021 19:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238323AbhIETKH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 5 Sep 2021 15:10:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27389 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238408AbhIETI7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 5 Sep 2021 15:08:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630868873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GBTVYvl6r/DGTmkrkWcHeYmKn9Wnjnzo76ZSWSpnbek=;
        b=PeqfpFtOcgYLHpImbilspXx7NNcD9AFdc1+vbYZSW8XLdVNXxdpUyIBE6a8Jd//2ySrAW3
        A3Rarm2+FChvFF82fOeq1qd0qcEaGVFxiA7bu3YZinBh2cKjqLW0qR2oAdLuSd4aERoPN5
        DrpsC4lYjcWWoLLXHz6HAA10siuMJ7o=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-OygONqcPMle_m2NtZ0rpeQ-1; Sun, 05 Sep 2021 15:07:53 -0400
X-MC-Unique: OygONqcPMle_m2NtZ0rpeQ-1
Received: by mail-wm1-f72.google.com with SMTP id p11-20020a05600c204b00b002f05aff1663so2323574wmg.2
        for <linux-unionfs@vger.kernel.org>; Sun, 05 Sep 2021 12:07:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=GBTVYvl6r/DGTmkrkWcHeYmKn9Wnjnzo76ZSWSpnbek=;
        b=aZ/BqIYeEm/EOIB8Yu6wPF9iorIC7iG8zVpwA/++zXAQ3PCRgsaoNGhykIOdgmS126
         tQYTi4KYJMGCY0Cep5beRPtm+/4r1nyQbDUMW0Lu9PvWnoZfKqGsfM5IVgKviuzOwofh
         u8qrwSvBC4BbgARgdEsQWQ6elc0hExF2wAg50BNkqwcUE63UqJRf8M59214PvuspkZTC
         j3KMW54v6VxHA5SwgK6iutU8t1yzqLAZKLcYCPUPWuBzjyfBbnJJo+NPQkbEu9qQ5jsK
         GFKdglZNEvGAY5IB+I2yODs46o8V7E3BeoUADfDq4STNQI9mSBkiqmEa1LY9sJ943Pfn
         2MAw==
X-Gm-Message-State: AOAM532vyu5cAL7VY+Nr3zImNbcsAzLpt1mD7F7CSjOYzGrHztY7RMNH
        +3NC0CRT9NNnAFE4CU6L90ROXBFRCK9NYVyggkUnhY1qVelAYVLwCfpVyxqJFE8IVAn90HpiZZH
        2SROGuvFGxTe2o0pzC+pSTRPwRg==
X-Received: by 2002:adf:916f:: with SMTP id j102mr9428613wrj.422.1630868871761;
        Sun, 05 Sep 2021 12:07:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJKpXpbX8Zx9j1c0iF75tnA3gLF7m6WMhftI7dZFfieFpkJUATagtI6L+4VC8O/dknnYxpxg==
X-Received: by 2002:adf:916f:: with SMTP id j102mr9428550wrj.422.1630868871507;
        Sun, 05 Sep 2021 12:07:51 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6f04.dip0.t-ipconnect.de. [91.12.111.4])
        by smtp.gmail.com with ESMTPSA id i20sm5300193wml.37.2021.09.05.12.07.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Sep 2021 12:07:51 -0700 (PDT)
Subject: Re: [PATCH v2 1/7] binfmt: don't use MAP_DENYWRITE when loading
 shared libraries via uselib()
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
        =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>,
        Florian Weimer <fweimer@redhat.com>,
        David Laight <David.Laight@aculab.com>,
        linux-unionfs@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
References: <20210816194840.42769-1-david@redhat.com>
 <20210816194840.42769-2-david@redhat.com>
 <20210905153229.GA3019909@roeck-us.net>
 <CAHk-=whO-dnNxz5H8yfnGsNxrDHu-TVQq-X-VwhoDyWu3Lgnyg@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <77b36c45-773b-3cb8-fa18-45f0914c3090@redhat.com>
Date:   Sun, 5 Sep 2021 21:07:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=whO-dnNxz5H8yfnGsNxrDHu-TVQq-X-VwhoDyWu3Lgnyg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 05.09.21 19:17, Linus Torvalds wrote:
> On Sun, Sep 5, 2021 at 8:32 AM Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> Guess someone didn't care compile testing their code. This is now in
>> mainline.
> 
> To be fair, a.out is disabled pretty much on all relevant platforms these days.

Yes, and it seems like it was disabled in all configs I used. (I did not 
compile all-yes configs; usually my stuff goes via -mm where it will end 
up in -next for a while ... this one was special)

> 
> Only alpha and m68k left, I think.
> 
> I applied the obvious patch from Geert.

Thanks Linus!


-- 
Thanks,

David / dhildenb

