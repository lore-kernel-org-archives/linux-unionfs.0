From: Fabian Sturm <fabian.sturm@aduu.de>
Subject: Multiple lower layers - presedence?
Date: Mon, 05 Jan 2015 02:29:04 +0100
Message-ID: <13541642.4YrjBhCzAu@debian-desktop-mine>
References: <1997646.dsfVWM3xr5@debian-desktop-mine>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx01.mykolab.com ([95.128.36.1]:54266 "EHLO mx04.mykolab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911AbbAEB3M (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Sun, 4 Jan 2015 20:29:12 -0500
In-Reply-To: <1997646.dsfVWM3xr5@debian-desktop-mine>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

The current documentation of overlayfs states the following:


Multiple lower layers
---------------------

Multiple lower layers can now be given using the the colon (":") as a
separator character between the directory names.  For example:

  mount -t overlay overlay -olowerdir=/lower1:/lower2:/lower3 /merged

As the example shows, "upperdir=" and "workdir=" may be omitted.  In that 
case
the overlay will be read-only.


Consider the case /lower1/A and /lower2/A exist.
What is part of the api - that it is undefined or that one takes presedence 
over the other?
It would be nice to have this clarified in the documentation.

Thanks,
Fabian

