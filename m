From: Jordi Pujol Palomer <jordipujolp@gmail.com>
Subject: Re: overlayfs 3.18-rc3 General protection fault
Date: Tue, 4 Nov 2014 17:03:53 +0100
Message-ID: <20141104170353.471e01d6@gmail.com>
References: <20141104135408.16f70754@gmail.com>
	<20141104151103.GA2540@tucsk.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:54787 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbaKDQD6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 4 Nov 2014 11:03:58 -0500
Received: by mail-wg0-f48.google.com with SMTP id m15so8476806wgh.35
        for <linux-unionfs@vger.kernel.org>; Tue, 04 Nov 2014 08:03:56 -0800 (PST)
In-Reply-To: <20141104151103.GA2540@tucsk.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>

EL Tue, 4 Nov 2014 16:11:03 +0100
Miklos Szeredi <miklos@szeredi.hu> escrigu=C3=A9:

> Thanks for the report.  Could you please try the following patch,
> which should fix the Oops.

OK, compiled and tested=20
it works !

Thanks,

Jordi Pujol

--
To unsubscribe from this list: send the line "unsubscribe linux-unionfs=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
