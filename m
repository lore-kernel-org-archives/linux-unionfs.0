From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC][PATCH 03/13] ovl: lookup redirect by file handle
Date: Tue, 18 Apr 2017 14:32:04 -0400
Message-ID: <20170418183204.GE9056@redhat.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
 <1492387183-18847-4-git-send-email-amir73il@gmail.com>
 <20170418130554.GB9056@redhat.com>
 <CAOQ4uxi2a3K-a2A2RghSsJxf7QEP8Mcb4P_dyygYq=eggAi8SQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59542 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751300AbdDRScG (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 18 Apr 2017 14:32:06 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi2a3K-a2A2RghSsJxf7QEP8Mcb4P_dyygYq=eggAi8SQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Apr 18, 2017 at 05:05:12PM +0300, Amir Goldstein wrote:

[..]
> > (This ovl_lookup() logic has become really twisted now. I wished it was
> >  little easier to read.)
> >
> 
> Me too. IMO, most of the complexity is in the fallbacks from redirect
> by fh to full path to relative path. Eliminating some of these fallbacks
> and maybe having separate lookup op per mode, may simplify the code.

In general, why are we falling back to path based lookup. If lower dirs
were copied or something else, that's a configuration error and overlayfs
will have undefined behavior?

Vivek
