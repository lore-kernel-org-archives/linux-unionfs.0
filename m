From: David Howells <dhowells@redhat.com>
Subject: Re: Problem writing to ovl with CIFS as lower dir
Date: Thu, 04 Feb 2016 16:11:13 +0000
Message-ID: <16233.1454602273@warthog.procyon.org.uk>
References: <56B37622.40604@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965006AbcBDQLP (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 4 Feb 2016 11:11:15 -0500
In-Reply-To: <56B37622.40604@kyup.com>
Content-ID: <16232.1454602273.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Nikolay Borisov <kernel@kyup.com>
Cc: dhowells@redhat.com, Miklos Szeredi <miklos@szeredi.hu>, SiteGround Operations <operations@siteground.com>, linux-unionfs@vger.kernel.org

Ummm...  I wouldn't've thought that CIFS was allowed as the lower dir since it
supports case-independent filenames.

David
