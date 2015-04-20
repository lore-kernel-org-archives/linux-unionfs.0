From: "A. Wan" <jm@mokwan.com>
Subject: Re: use scenario for overlay FS
Date: Mon, 20 Apr 2015 16:01:51 -0700
Message-ID: <6c73aa7ee25cebcca7e5564ccc57b1e7.squirrel@www.anemaid>
References: <553567AF.20205@lge.com>
Reply-To: jm@mokwan.com
Mime-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.webnames.ca ([65.39.140.87]:53240 "EHLO mx2.webnames.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbbDTXTR (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 20 Apr 2015 19:19:17 -0400
Received: from anemaid.no-ip.org (d162-156-163-29.bchsia.telus.net [162.156.163.29]) by mx2.webnames.ca with ESMTP id XjthUyRnF8REe1rG for <linux-unionfs@vger.kernel.org>; Mon, 20 Apr 2015 16:02:34 -0700 (PDT)
In-Reply-To: <553567AF.20205@lge.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
Cc: "neilb@suse.de" <neilb@suse.de>, "miklos@szeredi.hu" <miklos@szeredi.hu>, Iyad Qumei <iyad.qumei@lge.com>

> Hi Neil,
>
> Regarding the overlayfs implementation, I am interested in overlaying
> two squashfs file systems, read-only, and running into a problem with
> location of the work directory:
>
>   "overlayfs: workdir and upperdir must reside under the same mount"
>
> Since the upper directory is read-only, and it is mounted on a partition
> as such, having writable work directory is not possible. Any suggestions
> on how to utilize overlayfs in this scenario?
>
> I feel this restriction is overkill for the feature.
>
> --
> Thanks,
> Iyad

I thought upperdir is now optional but must be read-write if one is
specified.  Therefore if you want the whole stack read-only specify only
lowdirs and skip the upperdir.  Correct me if I am wrong.

Alex
