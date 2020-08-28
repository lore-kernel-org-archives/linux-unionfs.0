Return-Path: <SRS0=7Ve9=CG=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13814C433E2
	for <linux-unionfs@archiver.kernel.org>; Fri, 28 Aug 2020 15:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC51920825
	for <linux-unionfs@archiver.kernel.org>; Fri, 28 Aug 2020 15:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbgH1PhT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 28 Aug 2020 11:37:19 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53440 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbgH1PhC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 28 Aug 2020 11:37:02 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1kBgR2-009Hwp-Ey; Fri, 28 Aug 2020 09:37:00 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1kBgR1-0008Vh-Mz; Fri, 28 Aug 2020 09:37:00 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Linux Containers <containers@lists.linux-foundation.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
References: <CAOQ4uxjXZdXZAaeiJ_p9n7NJziBv2yvWqSDs0hDd1ONUrVKxOQ@mail.gmail.com>
Date:   Fri, 28 Aug 2020 10:33:16 -0500
In-Reply-To: <CAOQ4uxjXZdXZAaeiJ_p9n7NJziBv2yvWqSDs0hDd1ONUrVKxOQ@mail.gmail.com>
        (Amir Goldstein's message of "Tue, 25 Aug 2020 09:07:04 +0300")
Message-ID: <87tuwmiy4j.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1kBgR1-0008Vh-Mz;;;mid=<87tuwmiy4j.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+UEvHHyKyN1lFrfwsVXfqd0dqui9Ko9ME=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: Overlayfs @Plumbers
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Amir Goldstein <amir73il@gmail.com> writes:

> Hi Guys,
>
> It's been nice to virtually meet with you yesterday.
> Some of you wanted to follow up on overlayfs related issues.
>
> If you want to discuss, try to find me in one of the
> https://meet.2020.linuxplumbersconf.org/hackrooms
> today between 16:00-17:00 UTC
> (No need to enter the room to see who's inside)
>
> If those times do not work for you, contact me and we can try
> to schedule another time.

Did this conversation wind up happening?  Do we need to reschedule?

Eric
