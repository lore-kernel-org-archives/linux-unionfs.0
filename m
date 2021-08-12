Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED568C4320A
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Aug 2021 19:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEE4460FBF
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Aug 2021 19:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbhHLTjA (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 15:39:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40838 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233300AbhHLTjA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Aug 2021 15:39:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628797113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tGJibS4yiaglb2J5rU+JWBqNKg1kdcrr0OdS+mMkHrI=;
        b=YsZPejHEDNuP59u5DgBvk4kho1KqLMikTMva8fQFqGcUB5Zv/X5np47jKoEAhQC2o1/3fw
        XN1GGdkS/lNaYiTeY0hEC4I1CJpgS5MlUQCo/bXS7Tot3QgIFzp+/Wbu7B36XlIjkIkYI3
        7taUgRmjsZlLW+RzVkCA0VgaR/0r4K4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-yLJ41AEsMhCb6UruHmHI2g-1; Thu, 12 Aug 2021 15:38:32 -0400
X-MC-Unique: yLJ41AEsMhCb6UruHmHI2g-1
Received: by mail-wm1-f70.google.com with SMTP id g70-20020a1c20490000b02902e6753bf473so3762483wmg.0
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Aug 2021 12:38:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=tGJibS4yiaglb2J5rU+JWBqNKg1kdcrr0OdS+mMkHrI=;
        b=MVsWUy8KEdJLvClc+FsXRUPsbFnUMQeBj/xlBaMWJFcGDoSTZw53LWqskb4ky7czjL
         b79cyvCFp/Sjv4c+V5SYOtL+SOFkbJpAsdTlbbWWbNprL1YCzdIdbfX1ao4iIRBIaAAm
         Ha43QZUeybPJ97tEgG3W8aYWfJV31I+vcvQTW9yUEcUk92WKtkPFjua+2YKVMzV+UOQb
         iw6pROKmdlwWPNDAO48fmTYsMRv0ROTYqk0j7yrq+bB96jVr9pgnfaBo8C/tcgpsMY+9
         x8MZa/+Pd1wrYsX/nK/GWmxJcvjE75qO6SwEWUMnoANCgSfqCLs9+nvWJOL0r37G1PKd
         kzUQ==
X-Gm-Message-State: AOAM532K+69ZEBKkEULGU5eCHOaqwkcuE7pbG2UaK25NVQo6BpR4yuvW
        xYSSUpbjJGv9k21g+rWKt+dX7WA+9q02+VVWNm2F7Phh49iLMAzsN1g473tFN1yYVHn4H/P8M3E
        XQsqKDEaC31FpZ9FEZGD1E5OFyA==
X-Received: by 2002:a5d:45c2:: with SMTP id b2mr5697488wrs.188.1628797111136;
        Thu, 12 Aug 2021 12:38:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2yA9S5GLR5aZS72Vs7D04/GT/ipvgAFBAJrXhJd9/Q2ngghrrOQ4av0TFSdLK0A6HDNvrvg==
X-Received: by 2002:a5d:45c2:: with SMTP id b2mr5697441wrs.188.1628797110959;
        Thu, 12 Aug 2021 12:38:30 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23d8b.dip0.t-ipconnect.de. [79.242.61.139])
        by smtp.gmail.com with ESMTPSA id i9sm4899610wre.36.2021.08.12.12.38.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 12:38:29 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
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
        =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>,
        linux-unionfs@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
References: <20210812084348.6521-1-david@redhat.com>
 <20210812084348.6521-4-david@redhat.com>
 <CAHk-=wjWgFbEaE9T0smQu8WKkhrcNZZrghBUQ9441OdMsDg1-w@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v1 3/7] kernel/fork: always deny write access to current
 MM exe_file
Message-ID: <15628c8a-9c71-5611-2edf-07087ad662b7@redhat.com>
Date:   Thu, 12 Aug 2021 21:38:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wjWgFbEaE9T0smQu8WKkhrcNZZrghBUQ9441OdMsDg1-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 12.08.21 18:51, Linus Torvalds wrote:
> On Wed, Aug 11, 2021 at 10:45 PM David Hildenbrand <david@redhat.com> wrote:
>>
>>          /* No ordering required: file already has been exposed. */
>> -       RCU_INIT_POINTER(mm->exe_file, get_mm_exe_file(oldmm));
>> +       exe_file = get_mm_exe_file(oldmm);
>> +       RCU_INIT_POINTER(mm->exe_file, exe_file);
>> +       if (exe_file)
>> +               deny_write_access(exe_file);
> 
> Can we make a helper function for this, since it's done in two different places?

Sure, no compelling reason not to (except finding a suitable name, but 
I'll think about that tomorrow).

> 
>> -       if (new_exe_file)
>> +       if (new_exe_file) {
>>                  get_file(new_exe_file);
>> +               /*
>> +                * exec code is required to deny_write_access() successfully,
>> +                * so this cannot fail
>> +                */
>> +               deny_write_access(new_exe_file);
>> +       }
>>          rcu_assign_pointer(mm->exe_file, new_exe_file);
> 
> And the above looks positively wrong. The comment is also nonsensical,
> in that it basically says "we thought this cannot fail, so we'll just
> rely on it".

Well, it documents the expectation towards the caller, but in a 
suboptimal way, I agree.

> 
> If it truly cannot fail, then the comment should give the reason, not
> the "we depend on this not failing".

Right, "We depend on the caller already have done a deny_write_access() 
successfully first such that this call cannot fail." combined with

if (deny_write_access(new_exe_file))
	pr_warn("Unexpected failure of deny_write_access() in %s",
                  __func__);

suggestions welcome.

> 
> And honestly, I don't see why it couldn't fail. And if it *does* fail,
> we cannot then RCU-assign the exe_file pointer with this, because
> you'll get a counter imbalance when you do the allow_write_access()
> later.

Anyone calling set_mm_exe_file() (-> begin_new_exec()) is expected to 
successfully triggered a deny_write_access() upfront such that we won't 
fail at that point.

Further, on the dup_mmap() path we are sure the previous oldmm exe_file 
properly saw a successful deny_write_access() already, because that's 
now guaranteed for any exe_file.

> 
> Anyway, do_open_execat() does do deny_write_access() with proper error
> checking. I think that is the existing reference that you depend on -
> so that it doesn't fail. So the comment could possibly say that the
> only caller has done this, but can we not just use the reference
> deny_write_access() directly, and not do a new one here?

I think that might over-complicate the exec code where we would see a 
allow_write_access() on error paths, but not on success paths. This here 
looks cleaner to me, agreeing that the comment and the error check has 
to be improved.

We handle all allow_write_access()/deny_write_access() regarding 
exe_file completely in kernel/fork.c, which is IMHO quite nice.

> 
> IOW, maybe there's an extraneous 'allow_write_access()' somewhere that
> should be dropped when we do the whole binprm dance in execve()?

fs/exec.c: free_bprm() and exec_binprm() to be precise.

Thanks!

-- 
Thanks,

David / dhildenb

