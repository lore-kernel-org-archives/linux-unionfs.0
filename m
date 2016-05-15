From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: Deadlock with overlayfs over and IMA/EVM-enabled filesystem
Date: Sun, 15 May 2016 14:24:38 -0400
Message-ID: <1463336678.14611.24.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([125.16.236.8]:59966 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbcEOSYt (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sun, 15 May 2016 14:24:49 -0400
Received: from localhost
	by e28smtp08.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-unionfs@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Sun, 15 May 2016 23:54:45 +0530
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 178FF125805B
	for <linux-unionfs@vger.kernel.org>; Sun, 15 May 2016 23:56:53 +0530 (IST)
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay05.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u4FIOeKh18940180
	for <linux-unionfs@vger.kernel.org>; Sun, 15 May 2016 23:54:40 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u4FIOevD022843
	for <linux-unionfs@vger.kernel.org>; Sun, 15 May 2016 23:54:41 +0530
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Krisztian Litkey <hackgyver@gmail.com>
Cc: linux-unionfs@vger.kernel.org

Hi Krisztian,

(Reposting my response as it never made it to the mailing list.)

>   Hi,
> 
> I've run into a reliably reproducible deadlock/reversed locking order
> bug involving overlayfs and IMA-enabled filesystems. It can be
> triggered very simply by constructing a read-write overlay using
> lower, upper, and work directories all on IMA-enabled filesystems.
> With such a setup simply trying to create an empty file by touch
> triggers the bug. Retrying the same thing with the upper and work
> directories on an IMA-ignored filesystem (for instance on a tmpfs)
> avoids the problem. From the stack trace it looks like we get into the
> deadlock when IMA tries to update the extended attribute for the newly
> created file which calls thru vfs into overlayfs.

Right, ima_file_free(), which is called from __fput(), writes the file
hash as a security xattr.  This seems to trigger the overlay's writing
of the xattr.  Testing if the S_IMA flag is set before taking the
i_mutex would probably prevent the lockdep.

> The setup is arguably a corner case (I don't think there are hoards of
> folks trying to mix overlays with IMA), but I'm not sure if the same
> problem could be triggered by something less pathological.

Deferring __fput() was introduced back in 2012 in order for IMA to take
the i_mutex.  So it shouldn't be a problem.

Mimi
