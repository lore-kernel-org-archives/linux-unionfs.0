From: Vincent Batts <vbatts@gmail.com>
Subject: Re: [PATCH] unionmount-testsuite: test rmdir of non-empty opaque dir
Date: Sun, 17 May 2015 16:45:52 -0400
Message-ID: <CAN6Zp5ypohsUf8tj6BaO3oBWVJ1cMTejNvCY18aQvatGM34-xQ@mail.gmail.com>
References: <20150513151502.GB19583@tucsk.suse.de>
	<CAN6Zp5xCn2GGxkBeOopy_7QaSjkq4XjEqbKn--4kbA-GzfP-Mg@mail.gmail.com>
	<27824.1431600403@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:38679 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbbEQUpy (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sun, 17 May 2015 16:45:54 -0400
Received: by wicnf17 with SMTP id nf17so48454285wic.1
        for <linux-unionfs@vger.kernel.org>; Sun, 17 May 2015 13:45:52 -0700 (PDT)
In-Reply-To: <27824.1431600403@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Josh Boyer <jwboyer@fedoraproject.org>, linux-unionfs@vger.kernel.org

On Thu, May 14, 2015 at 6:46 AM, David Howells <dhowells@redhat.com> wrote:
> Vincent Batts <vbatts@gmail.com> wrote:
>
>> I'm not familiar with this testsuite. The empty_dir will be on the
>> lower level, and all the rmdir, mkdir and create are happening on a
>> mounted union fs? I don't see where that is clear.
>
> That's handled by the core of the test infrastructure:
>
>         http://git.infradead.org/users/dhowells/unionmount-testsuite.git
>
> Look in the base of the git tree.
>
> The infrastructure creates a load of files and other objects then sets up the
> requested union (unionmount, overlayfs or even no union at all) over them and
> then runs all the tests.
>
> David

RIght on. Thanks.

vb
