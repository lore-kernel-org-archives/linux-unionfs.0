Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 292D5C433B4
	for <linux-unionfs@archiver.kernel.org>; Sat, 10 Apr 2021 19:34:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF64B6102A
	for <linux-unionfs@archiver.kernel.org>; Sat, 10 Apr 2021 19:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234708AbhDJTfN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 10 Apr 2021 15:35:13 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:60406 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbhDJTfN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 10 Apr 2021 15:35:13 -0400
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id 13AJYs21008575;
        Sat, 10 Apr 2021 12:34:56 -0700
Message-ID: <6071FDE0.2070009@tlinx.org>
Date:   Sat, 10 Apr 2021 12:34:56 -0700
From:   L A Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To:     Amir Goldstein <amir73il@gmail.com>
CC:     overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: odd error: why: mount: /home2: mount(2) system call failed: Stale
 file handle
References: <606F526A.1040405@tlinx.org> <CAOQ4uxj4bdzcdcy7jpkRCZTNv=4b8BPVVP+1L_3OLWFwMnV-kQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxj4bdzcdcy7jpkRCZTNv=4b8BPVVP+1L_3OLWFwMnV-kQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 2021/04/08 22:44, Amir Goldstein wrote:
> It is generally not allowed to reuse the upper layer and replace the
> lower layers after overlayfs has been mounted once.
>
> If you say you did not change anything, it is not clear what is the
> benefit of reusing  the empty upper layer.
>   
---
    I can understand that, the upper layer is an empty fs+work dir
with no changes.  It was attached to the wrong lower layer,
unattached/unmounted.

    I then made sure both upper+work were both empty and tried again
elsewhere.  I want to avoid unnecessary steps, so destroying and recreating
an empty partition didn't seem logical.  How do you disassociate a
previous connected state?  What needs to be initialized on the
unmounted upper and working dir (on the same fs), to reuse the same
file system?



