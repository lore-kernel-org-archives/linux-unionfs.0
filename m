From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Overlayfs: ovl_fill_merge() should use container_of() rather than direct cast
Date: Thu, 30 Oct 2014 14:47:06 +0000
Message-ID: <5760.1414680426@warthog.procyon.org.uk>
References: <CAJfpegv5dqfgze-9pxDD-O19tctS-4P12NsO2oCo5SF1bqhhHA@mail.gmail.com> <20141030141004.28203.79687.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760159AbaJ3OrP (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 30 Oct 2014 10:47:15 -0400
In-Reply-To: <CAJfpegv5dqfgze-9pxDD-O19tctS-4P12NsO2oCo5SF1bqhhHA@mail.gmail.com>
Content-ID: <5759.1414680426.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org, Kernel Mailing List <linux-kernel@vger.kernel.org>

Miklos Szeredi <miklos@szeredi.hu> wrote:

> Okay, but why don't we have a typed argument of actor then?

You should ask that one to Al.

David
