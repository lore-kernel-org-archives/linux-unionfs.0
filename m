From: Krisztian Litkey <kli@iki.fi>
Subject: Don't deadlock when setting IMA extended attributes
Date: Sun, 15 May 2016 13:14:25 -0400
Message-ID: <1463332466-26930-1-git-send-email-kli@iki.fi>
References: <201605150256.u4F2uQnX030109@d03av04.boulder.ibm.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:33488 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbcEOROw (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sun, 15 May 2016 13:14:52 -0400
Received: by mail-lb0-f171.google.com with SMTP id jj5so43308339lbc.0
        for <linux-unionfs@vger.kernel.org>; Sun, 15 May 2016 10:14:51 -0700 (PDT)
In-Reply-To: <201605150256.u4F2uQnX030109@d03av04.boulder.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: zohar@us.ibm.com

  Hi,

Here is my attempt at rolling a fix for the deadlock, based on
your suggestions. Does this resemble anything you had in mind ?

And to be honest, while the original deadlock seems to be gone,
this feels disturbingly 'opportunistic programming' for me. I
haven't touched any filesystem code in the kernel before so I
really have no idea if this is anywhere near as it should be.
Someone who understands something about the VFS and LSM hooks
should check this. And also should check if the resulting side-
effects are okay from a security perspective: the original code
path calls security_inode_setxattr while the new code path for
IMA attributes does not call it.

  Cheers,
    Krisztian
