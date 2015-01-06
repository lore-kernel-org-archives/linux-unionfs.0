From: intrigeri <intrigeri@boum.org>
Subject: Re: Multiple lower layers - presedence?
Date: Tue, 06 Jan 2015 16:59:03 +0100
Message-ID: <85r3v799yw.fsf@boum.org>
References: <1997646.dsfVWM3xr5@debian-desktop-mine>
	<13541642.4YrjBhCzAu@debian-desktop-mine>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from boum.org ([204.13.164.192]:55704 "EHLO boum.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750AbbAFQEy (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 6 Jan 2015 11:04:54 -0500
Received: from localhost (censure.boum.org [192.168.122.20])
	by boum.org (Postfix) with ESMTP id 468855D5C
	for <linux-unionfs@vger.kernel.org>; Tue,  6 Jan 2015 16:59:13 +0100 (CET)
Received: from boum.org ([192.168.122.29])
	by localhost (censure.boum.org [192.168.122.20]) (amavisd-new, port 10024)
	with ESMTP id I2HD4zbFHKyz for <linux-unionfs@vger.kernel.org>;
	Tue,  6 Jan 2015 16:59:12 +0100 (CET)
In-Reply-To: <13541642.4YrjBhCzAu@debian-desktop-mine> (Fabian Sturm's message
	of "Mon, 05 Jan 2015 02:29:04 +0100")
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Hi,

Fabian Sturm wrote (05 Jan 2015 01:29:04 GMT) :
> Consider the case /lower1/A and /lower2/A exist.
> What is part of the api - that it is undefined or that one takes presedence 
> over the other?
> It would be nice to have this clarified in the documentation.

IMO this should be specified. I would intuitively believe that
a right-hand lowerdir should take precedence over any left-hand one,
but my intuition definitely is tainted by cultural background that not
everyone shares, so it's probably worth looking at how it's done in
aufs, to make migration easier for aufs users.

Cheers,
--
intrigeri
