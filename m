From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: d_path() and overlay fs
Date: Fri, 20 Mar 2015 16:25:58 +0000
Message-ID: <20150320162558.GA29656@ZenIV.linux.org.uk>
References: <20150320132914.GA1749@ws.net.home>
 <CA+5PVA6P3cEy9L+PngXdkVki=x32jZmtPJ2b5oT6SLL=U1NAnw@mail.gmail.com>
 <20150320160123.GE20913@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:59468 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbbCTQ0C (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 20 Mar 2015 12:26:02 -0400
Content-Disposition: inline
In-Reply-To: <20150320160123.GE20913@tucsk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Karel Zak <kzak@redhat.com>, dhowells@redhat.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org

On Fri, Mar 20, 2015 at 05:01:23PM +0100, Miklos Szeredi wrote:

> But it does take care of the majority of f_path users that actually want the
> covering path.

Bloody bad idea, IMO.  I have no objections against adding _helpers_ from
that patch (seq_file_path(), etc.), but I really don't like adding that
second struct path there.  And it still doesn't fix the issue with
LSM, etc., so we'll _still_ need to fix it sane way.
