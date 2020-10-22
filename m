Return-Path: <SRS0=zl3V=D5=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01437C388F2
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Oct 2020 13:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A5FF222E9
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Oct 2020 13:18:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=android.com header.i=@android.com header.b="sPxj/eeS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2899475AbgJVNSG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 22 Oct 2020 09:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2899470AbgJVNSF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Oct 2020 09:18:05 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619CFC0613CF
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Oct 2020 06:18:05 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id b6so813023pju.1
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Oct 2020 06:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=c5p1zV1CqKVH8prpsj7PEX/s64deTtbH6mLHz/sTWPo=;
        b=sPxj/eeSkGniZwpwGV+0kEAq//Ks1jlWunt480rMLYVSZRIi4xZOoKAn9mkn5HYPkN
         Fkw7AxIajl0UYvbLyw5iKfkrY3DUZs7/K5NVP0ecCTnIx4XoITfdeSBZU9NLP3nJbR+F
         m/CP8lnN5y45pgRiZup/NSe3sXBPCK7l1KQFu1/5XhbAsdix6UTYgjsk5NHZUggsf+R+
         buouCHVOu8EJVTknoEH0SXsWkVrr8c8UNxqUbrsdOW6XsWwDwjpR++Idct8cm2lU+IO3
         4ycrvMIJ47PM0kZ2TAbRvP2JqSFxdRFAQ6RAz6wopnTtNzOjDYWuHQiGClajvFJGWlHo
         G06Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=c5p1zV1CqKVH8prpsj7PEX/s64deTtbH6mLHz/sTWPo=;
        b=tu7n6/DLYZwQ7soZ6tGu+exoUqWjHxmNs98hGR/yc5VE9apr7wGTgzGjrlLuzXR1XO
         2LipBbu+G4N6z2iCZBWmiB+G6LPGKHP88Ag/EMLzuhcYW9Sh2PIN6sDqN7+O1HI4VKF4
         U3Rt0bJnPDZJDN3j6pV6hJo9LZg+R9M1IpgYdrZa891oHZDy3bc7QjIkm4NqwpYnkaB4
         mOwSgS2xBJ7FKfCv/puA5pwxGlGDjR0E9mf9GWW3vqTzrqUfeVHFrq5OdXALSmw24UV7
         4GrKXJPTdlmcxblLczSakZ6+ybx6DtPYUIdff3Pm/wx5WEiEzJnBiqwKkbF+nBkxkiRm
         BK5A==
X-Gm-Message-State: AOAM532vE/stMwHIaQbq7H1Bjv8OG6Ko5gG0JV9pTEr8Z5djSReZsCTQ
        kgz9CE0LdrI7ksvRV1qt4+IC3A==
X-Google-Smtp-Source: ABdhPJxFrJ8OvG+hbFts8koI3B46u1glVYhDvP6t0s8IfoVfSWdoLhC5db0WuzzwbxtbgXYlT10aAw==
X-Received: by 2002:a17:902:b40a:b029:d5:f77c:fb4e with SMTP id x10-20020a170902b40ab02900d5f77cfb4emr2576354plr.14.1603372684980;
        Thu, 22 Oct 2020 06:18:04 -0700 (PDT)
Received: from nebulus.mtv.corp.google.com ([2620:15c:211:200:4a0f:cfff:fe35:d61b])
        by smtp.googlemail.com with ESMTPSA id w19sm2248589pfn.174.2020.10.22.06.18.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2020 06:18:04 -0700 (PDT)
Subject: Re: [RESEND PATCH v18 0/4] overlayfs override_creds=off & nested get
 xattr fix
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        Miklos Szeredi <miklos@szeredi.hu>,
        Jonathan Corbet <corbet@lwn.net>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        John Stultz <john.stultz@linaro.org>,
        linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
References: <20201021151903.652827-1-salyzyn@android.com>
 <20201022051914.GI857@sol.localdomain>
From:   Mark Salyzyn <salyzyn@android.com>
Message-ID: <ea67453d-e5de-7c3a-e1da-d1e5ac30b2dd@android.com>
Date:   Thu, 22 Oct 2020 06:18:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201022051914.GI857@sol.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 10/21/20 10:19 PM, Eric Biggers wrote:
> On Wed, Oct 21, 2020 at 08:18:59AM -0700, Mark Salyzyn wrote:
>> Mark Salyzyn (3):
>>    Add flags option to get xattr method paired to __vfs_getxattr
>>    overlayfs: handle XATTR_NOSECURITY flag for get xattr method
>>    overlayfs: override_creds=off option bypass creator_cred
>>
>> Mark Salyzyn + John Stultz (1):
>>    overlayfs: inode_owner_or_capable called during execv
>>
>> The first three patches address fundamental security issues that should
>> be solved regardless of the override_creds=off feature.
>>
>> The fourth adds the feature depends on these other fixes.
> FYI, I didn't receive patch 4, and neither https://lkml.kernel.org/linux-fsdevel
> nor https://lkml.kernel.org/linux-unionfs have it either.
>
> - Eric

Resent again, thanks.

