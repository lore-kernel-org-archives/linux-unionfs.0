From: "A. Wan" <jm@mokwan.com>
Subject: Re: read-only upperdir since overlayfs.v22 or later
Date: Sat, 1 Nov 2014 06:37:13 -0700
Message-ID: <322e0856050a21eed8ebe33b34cefebe.squirrel@www.anemaid>
Reply-To: jm@mokwan.com
Mime-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.webnames.ca ([65.39.140.87]:46836 "EHLO mx2.webnames.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756389AbaKANtO (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Sat, 1 Nov 2014 09:49:14 -0400
Received: from anemaid.no-ip.org (d207-216-185-133.bchsia.telus.net [207.216.185.133]) by mx2.webnames.ca with ESMTP id cDZm2EEft9jsOQ5A for <linux-unionfs@vger.kernel.org>; Sat, 01 Nov 2014 06:37:24 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Is it impossible to have a read-only upperdir with overlayfs.v22 or later
since a read-write workdir must be on the same mount as upperdir?

Basically I would like to be able to stack more than one read-only layer
beneath a read-write top layer.

Sincerely,
Alex Wan



