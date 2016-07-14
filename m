From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: linux-next: Tree for Jul 14 (overlayfs)
Date: Thu, 14 Jul 2016 09:51:31 -0700
Message-ID: <1500d761-4145-f633-4a9a-c99b82149fab@infradead.org>
References: <20160714161846.3cea851a@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160714161846.3cea851a@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
List-Id: linux-unionfs@vger.kernel.org

On 07/13/16 23:18, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20160713:
> 

on i386, when:
# CONFIG_FS_POSIX_ACL is not set


fs/built-in.o: In function `ovl_posix_acl_xattr_set':
super.c:(.text+0x44223): undefined reference to `posix_acl_from_xattr'



-- 
~Randy
