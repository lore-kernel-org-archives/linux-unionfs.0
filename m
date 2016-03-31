From: Marc Haber <mh+linux-kernel@zugschlus.de>
Subject: Re: ext4_file_open: Inconsistent encryption contexts (commit
 ff978b09f973) breaking Docker
Date: Thu, 31 Mar 2016 22:39:34 +0200
Message-ID: <20160331203933.GA31018@torres.zugschlus.de>
References: <87io0t3ks9.fsf@gamma.ozlabs.ibm.com>
 <20160311021506.GA32214@thunk.org>
 <20160311153403.GJ8655@tucsk>
 <87ziu1eetp.fsf@gamma.ozlabs.ibm.com>
 <20160314102735.GM8655@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160314102735.GM8655@tucsk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Daniel Axtens <dja@axtens.net>, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, viro@zeniv.linux.org.uk, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Mar 14, 2016 at 11:27:35AM +0100, Miklos Szeredi wrote:
> Could you please try the below patch?

I can confirm that I have the issue on kernel 4.5 with Debian's
schroot using overlayfs, and that this patch fixes it.

It should be in 4.5.1.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
