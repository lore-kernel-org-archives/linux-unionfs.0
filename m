Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEC8BC433F5
	for <linux-unionfs@archiver.kernel.org>; Fri,  3 Sep 2021 09:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B436F60FC4
	for <linux-unionfs@archiver.kernel.org>; Fri,  3 Sep 2021 09:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348932AbhICJqI (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 3 Sep 2021 05:46:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56073 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348887AbhICJqH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 3 Sep 2021 05:46:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630662307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/vGWzQqDyFpKhyOh2wIj+Kx4GVFTcdYuhnpoMJMGvEA=;
        b=HOaWSbxaoOijHJtzyyvY+jf0zlsY3B4I917IjTuiLRM2TgCzjyYxgRfYPaUAjmmYVxyN2t
        SHrxkmUMa68gsbF05Pu5Wev5/6y0Sav5qdsEMts0p5OAlztJYRrSajm5VAQYBQy8sRk4ss
        KSrJNiV8K3vbG9IrSrs5ylcwRgF43gY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-L87hB9i0PZeS1Iws7Z1r5Q-1; Fri, 03 Sep 2021 05:45:06 -0400
X-MC-Unique: L87hB9i0PZeS1Iws7Z1r5Q-1
Received: by mail-wm1-f69.google.com with SMTP id s197-20020a1ca9ce000000b002e72ba822dcso2428555wme.6
        for <linux-unionfs@vger.kernel.org>; Fri, 03 Sep 2021 02:45:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=/vGWzQqDyFpKhyOh2wIj+Kx4GVFTcdYuhnpoMJMGvEA=;
        b=TGdvQBRAFtYMRPzSXni82TmgfyZPDCZfUUGcqZ/SY7dnmrb5oc8JxSkrefiG9fxZ8r
         xqF02F8WGK2lhLMG1hceI3cWckky9yZhfJXmkkyF716k0SpWSKH8TwN+54uILcITXIn1
         EGwugz9IKwwkcA8mP8ZybPPzcQ1bx7iZ/fMxyRA/3GsP5vqn9FOnc2IceC/M6ghPXA3L
         PL+HeoaqkU4FN6RHOffvTG/xdbNygK2URfWCXtNysIGNAZpYdXDzXJsLuiVSEnlYrQi9
         Pg/pMjwdNgIezV6EktwKw6oVRmw9iA+Ww/eIkpSyE0bqol4e/aoly8DoeIr4wjV9940L
         GXEA==
X-Gm-Message-State: AOAM532vnNIu3JZm7nMD1ctOX14n7aNWTMCwUU8N0T0u5QXh+/nD61sM
        rBzDF/aZJHAs8g90CAH7hBavCl3IyICrB/vP2bbQ7oi2Jfq8Mtav7+ULFxgnCBHtlxQOWwWqHNi
        2UirFph3qA/EJebcrFtT4QAZNNg==
X-Received: by 2002:a5d:534c:: with SMTP id t12mr2933325wrv.219.1630662305219;
        Fri, 03 Sep 2021 02:45:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwp4wZnhZMdzpuRGRjPbO89lNQeoyMiOxBHqBuOuGQAYy9XHQ2xW00EnKcwVfrZ6lqnhbC09Q==
X-Received: by 2002:a5d:534c:: with SMTP id t12mr2933309wrv.219.1630662305062;
        Fri, 03 Sep 2021 02:45:05 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23e05.dip0.t-ipconnect.de. [79.242.62.5])
        by smtp.gmail.com with ESMTPSA id v21sm4449203wra.92.2021.09.03.02.45.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 02:45:03 -0700 (PDT)
Subject: Re: [PATCH v2 0/7] Remove in-tree usage of MAP_DENYWRITE
To:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
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
        David Laight <David.Laight@ACULAB.COM>,
        linux-unionfs@vger.kernel.org, linux-api@vger.kernel.org,
        x86@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20210816194840.42769-1-david@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <7c57a16b-8184-36a3-fcdc-5e751184827b@redhat.com>
Date:   Fri, 3 Sep 2021 11:45:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210816194840.42769-1-david@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 16.08.21 21:48, David Hildenbrand wrote:
> This series removes all in-tree usage of MAP_DENYWRITE from the kernel
> and removes VM_DENYWRITE. We stopped supporting MAP_DENYWRITE for
> user space applications a while ago because of the chance for DoS.
> The last renaming user is binfmt binary loading during exec and
> legacy library loading via uselib().
> 

So, how do we want to continue with this? Pick it up for v5.15? Have it 
in -next for a while and eventually pick it up for v5.16?

I think the "remove ETXTBSY completely" and "remove the sanity mapping 
check" thingies should be done on top.

-- 
Thanks,

David / dhildenb

