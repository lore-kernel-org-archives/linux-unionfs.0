Return-Path: <SRS0=I5aa=7W=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16E37C433DF
	for <linux-unionfs@archiver.kernel.org>; Tue,  9 Jun 2020 16:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC20120737
	for <linux-unionfs@archiver.kernel.org>; Tue,  9 Jun 2020 16:53:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sfs/r+nz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731239AbgFIQx4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 9 Jun 2020 12:53:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59505 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729988AbgFIQx4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Jun 2020 12:53:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591721635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7xf0loN+bSKyI/1nYgCdJKSwWA5mvzJln10ufn+lIn0=;
        b=Sfs/r+nzeNtMj71cpAIM55xrI5EEcT+ZYDuFnsJiC0zPp23IkHvES+57OpDgz/UEf4F0Mt
        UT/ZUCfo9dOKcWtSMe5B4WOaHqTG68YG3CJcqaoKZU+Kqv7D8M5aEe39wL1ZFVOv48rLv1
        C+aPxOAIMy2H9ZBOitxa3kNzn255NJE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-slUI-swWNp-k---nybQIDg-1; Tue, 09 Jun 2020 12:53:53 -0400
X-MC-Unique: slUI-swWNp-k---nybQIDg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3E4D873014;
        Tue,  9 Jun 2020 16:53:51 +0000 (UTC)
Received: from llong.remote.csb (ovpn-117-140.rdu2.redhat.com [10.10.117.140])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DABF768DA;
        Tue,  9 Jun 2020 16:53:51 +0000 (UTC)
Subject: Re: lockdep issues with overlayfs
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org
References: <20200609150756.GA6171@miu.piliscsaba.redhat.com>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <fff3ed1b-e470-a184-a4ef-de84f47879ab@redhat.com>
Date:   Tue, 9 Jun 2020 12:53:50 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200609150756.GA6171@miu.piliscsaba.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 6/9/20 11:07 AM, Miklos Szeredi wrote:
> While running xfstests[1] on overlayfs I get the following:
>
> BUG: MAX_LOCKDEP_CHAIN_HLOCKS too low!
> turning off the locking correctness validator.
> [...]
>
> Then when doing cat /proc/lockdep_chains I get this Oops:
>
> BUG: unable to handle page fault for address: ffffffff83b36da8
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 2262067 P4D 2262067 PUD 2263063 PMD 0

Thanks for the information. There are some corruption in the lock chain 
data some garbage shows up in your lockdep_chains. I will try to 
reproduce the error to in order to figure out where the bug is.

Thanks,
Longman


