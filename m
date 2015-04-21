From: "A. Wan" <jm@mokwan.com>
Subject: Re: use scenario for overlay FS
Date: Tue, 21 Apr 2015 08:34:46 -0700
Message-ID: <38ef0b4c9d06fddaa46cc98977bc643a.squirrel@www.anemaid>
References: <553567AF.20205@lge.com>
    <6c73aa7ee25cebcca7e5564ccc57b1e7.squirrel@www.anemaid>
    <55358C3B.5090708@lge.com>
Reply-To: jm@mokwan.com
Mime-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.webnames.ca ([65.39.140.87]:43819 "EHLO mx2.webnames.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932753AbbDUPfe (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 21 Apr 2015 11:35:34 -0400
Received: from anemaid.no-ip.org (d162-156-163-29.bchsia.telus.net [162.156.163.29]) by mx2.webnames.ca with ESMTP id 0WDbcSKbNlj7GokG for <linux-unionfs@vger.kernel.org>; Tue, 21 Apr 2015 08:35:31 -0700 (PDT)
In-Reply-To: <55358C3B.5090708@lge.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Iyad Qumei <iyad.qumei@lge.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>, "miklos@szeredi.hu" <miklos@szeredi.hu>

Iyad wrote:
> I have two file systems that I need to create a union for.  The upperdir
> overrides the lowerdir, hence replacing its content. Therefore,
> regardless if the upperdir is optional, I do need it in this use case.
>
> Per the documentation:
>
>    "A read-only overlay of two read-only filesystems may use any
> filesystem type."
>
> I understood that my use case is possible. However, it does contradict
> the actual implementation,
>
>    "overlayfs: workdir and upperdir must reside under the same mount"
>
> and your statement, of course.
>
> Thanks,
> Iyad
>
> On 04/20/2015 04:01 PM, A. Wan wrote:
>> I thought upperdir is now optional but must be read-write if one is
>> specified.  Therefore if you want the whole stack read-only specify only
>> lowdirs and skip the upperdir.  Correct me if I am wrong.
>>
>> Alex

When they made upperdir= optional they also changed lowerdir= to allow a
(colon separated?) stack of directories.  I don't remember if they are
stacked from left to right or right to left.  I am sure it is in the
latest documentation.

Alex
