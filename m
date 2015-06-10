From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] overlayfs: Warn on copy up if a process has a R/O fd open to the lower file
Date: Wed, 10 Jun 2015 14:23:32 +0100
Message-ID: <30048.1433942612@warthog.procyon.org.uk>
References: <4954.1432838811@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933620AbbFJNXh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 10 Jun 2015 09:23:37 -0400
In-Reply-To: <4954.1432838811@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu, viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org


Hi Mikl=C3=B3s, Al,

Any thoughts on taking this upstream?

David
