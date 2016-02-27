From: Nazarov Sergey <s-nazarov@yandex.ru>
Subject: Re: [PATCH v2 1/1] OverlayFS: Fix checking permissions during lookup.
Date: Sat, 27 Feb 2016 13:40:02 +0300
Message-ID: <419661456569602@web21g.yandex.ru>
References: <20160224135552.GB8422@zenon.in.qult.net> <20160226194143.GB13054@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from forward12p.cmail.yandex.net ([87.250.241.138]:39308 "EHLO
	forward12p.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756253AbcB0KuC (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sat, 27 Feb 2016 05:50:02 -0500
In-Reply-To: <20160226194143.GB13054@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>, =?utf-8?B?SWduYWN5IEdhd8SZZHpraQ==?= <ignacy.gawedzki@green-communications.fr>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

26.02.2016, 22:41, "Vivek Goyal" <vgoyal@redhat.com>:
>
> So what's the problem we are trying to solve. Why should we able to
> override the DAC checks of lower layer if same directory in upper
> is searchable for user but it is not searchable in lower layer.
>

If I right, this is a one of the main feature of overlayfs - upper layer has priority over lower ones.
Override AC checks necessary for lookup operation only. Lower layer files access AC checks
remain, so this should not be a security problem.
Sergey.
