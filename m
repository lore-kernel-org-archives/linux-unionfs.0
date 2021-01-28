Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CE01C433E0
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Jan 2021 20:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DA9C64DE7
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Jan 2021 20:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbhA1Uvm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 15:51:42 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:57024 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhA1Uvi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Jan 2021 15:51:38 -0500
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1l5EFk-002oc7-0l; Thu, 28 Jan 2021 13:50:56 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1l5EFi-0007vO-Nl; Thu, 28 Jan 2021 13:50:55 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     "Serge E. Hallyn" <serge@hallyn.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        linux-fsdevel@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
References: <20210119162204.2081137-1-mszeredi@redhat.com>
        <20210119162204.2081137-3-mszeredi@redhat.com>
        <8735yw8k7a.fsf@x220.int.ebiederm.org>
        <20210128165852.GA20974@mail.hallyn.com>
        <87o8h8x1a6.fsf@x220.int.ebiederm.org>
        <CAJfpegv8e5+xn2X8-QrNnu0QJbe=CoK-DWNOdTV9EdrHrJvtEg@mail.gmail.com>
Date:   Thu, 28 Jan 2021 14:49:35 -0600
In-Reply-To: <CAJfpegv8e5+xn2X8-QrNnu0QJbe=CoK-DWNOdTV9EdrHrJvtEg@mail.gmail.com>
        (Miklos Szeredi's message of "Thu, 28 Jan 2021 21:38:00 +0100")
Message-ID: <87tur0vlb4.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1l5EFi-0007vO-Nl;;;mid=<87tur0vlb4.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19ay7DlYNZuYViioRwECggdIxy8OTBSDAk=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 2/2] security.capability: fix conversions on getxattr
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Thu, Jan 28, 2021 at 9:24 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> <aside>
>> From our previous discussions I would also argue it would be good
>> if there was a bypass that skipped all conversions if the reader
>> and the filesystem are in the same user namespace.
>> </aside>
>
> That's however just an optimization (AFAICS) that only makes sense if
> it helps a read world workload.   I'm not convinced that that's the
> case.

It is definitely a different issue.

From previous conversations with Serge, there is a concern with a
sysadmin wanting to see what is actually on disk.  In case there are
bugs that care about the different layout.  Just passing everything
through when no translation is necessary will allow that kind of
diagnosis.

As your patch demonstrates we already have had bugs in this area
so being able to get at the raw data may help people if they get into a
situation where bugs matter.

Eric
