Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F470C433E0
	for <linux-unionfs@archiver.kernel.org>; Thu, 11 Feb 2021 22:43:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D98A864DD7
	for <linux-unionfs@archiver.kernel.org>; Thu, 11 Feb 2021 22:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhBKWnP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 17:43:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44793 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230119AbhBKWnL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 11 Feb 2021 17:43:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613083305;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gkuO2jF74md4mKxRKx0thJapiv14GR9H43T6rL2M6II=;
        b=L6kNCVQ1+z9ksbY0zxn/+qJ9EJwOtfD4BxT0S8BXoFzpkcO+ilJ+ES8xgxNv9Hb5WYD7cW
        DFJa6s7icoDshGZEeF3fZL2M8jPiKtCbpnL/9mFmqBvdYa3oMmd6kN7XJqKi5YtaJm2Tj8
        ynvOGKylqXepvD7sBjXi3XXJNVllZzA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-7ATKfnEaP02d0GZhA934Cg-1; Thu, 11 Feb 2021 17:41:44 -0500
X-MC-Unique: 7ATKfnEaP02d0GZhA934Cg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB021107ACE3;
        Thu, 11 Feb 2021 22:41:42 +0000 (UTC)
Received: from localhost.localdomain (ovpn-113-192.phx2.redhat.com [10.3.113.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B33E32C166;
        Thu, 11 Feb 2021 22:41:40 +0000 (UTC)
Reply-To: dwalsh@redhat.com
Subject: Re: [PATCH][v2] selinux: Allow context mounts for unpriviliged
 overlayfs
To:     Paul Moore <paul@paul-moore.com>, Vivek Goyal <vgoyal@redhat.com>
Cc:     selinux@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>
References: <20210211180303.GE5014@redhat.com>
 <CAHC9VhRM6MiF1m2aFpLJKb3CFWXcXEX_SY=EnkLaq7U_X2UTZw@mail.gmail.com>
From:   Daniel Walsh <dwalsh@redhat.com>
Organization: Red Hat
Message-ID: <bb7b8304-b0fe-f6a3-b1fa-c06193f9cc02@redhat.com>
Date:   Thu, 11 Feb 2021 17:41:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CAHC9VhRM6MiF1m2aFpLJKb3CFWXcXEX_SY=EnkLaq7U_X2UTZw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 2/11/21 16:24, Paul Moore wrote:
> On Thu, Feb 11, 2021 at 1:03 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>> Now overlayfs allow unpriviliged mounts. That is root inside a non-init
>> user namespace can mount overlayfs. This is being added in 5.11 kernel.
>>
>> Giuseppe tried to mount overlayfs with option "context" and it failed
>> with error -EACCESS.
>>
>> $ su test
>> $ unshare -rm
>> $ mkdir -p lower upper work merged
>> $ mount -t overlay -o lowerdir=lower,workdir=work,upperdir=upper,userxattr,context='system_u:object_r:container_file_t:s0' none merged
>>
>> This fails with -EACCESS. It works if option "-o context" is not specified.
>>
>> Little debugging showed that selinux_set_mnt_opts() returns -EACCESS.
>>
>> So this patch adds "overlay" to the list, where it is fine to specific
>> context from non init_user_ns.
>>
>> v2: Fixed commit message to reflect that unpriveleged overlayfs mount is
>>      being added in 5.11 and not in 5.10 kernel.
>>
>> Reported-by: Giuseppe Scrivano <gscrivan@redhat.com>
>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> ---
>>   security/selinux/hooks.c |    3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
> Thanks Vivek, once the merge window closes I'll merge this into
> selinux/next and send a note to this thread.
>
In order for us to take advantage of rootless overlay we need this 
feature ASAP.

