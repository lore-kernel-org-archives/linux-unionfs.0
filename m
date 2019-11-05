From: Mark Salyzyn <salyzyn@android.com>
Subject: Re: [PATCH v15 0/4] overlayfs override_creds=off & nested get xattr
 fix
Date: Tue, 5 Nov 2019 07:20:10 -0800
Message-ID: <97c4108f-3a9b-e58b-56e0-dfe2642cc1f5@android.com>
References: <20191104215253.141818-1-salyzyn@android.com>
 <CAOQ4uxhoozGgxYmucFpFx8N=b4x9H3sfp60TNzf0dmU9eQi2UQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxhoozGgxYmucFpFx8N=b4x9H3sfp60TNzf0dmU9eQi2UQ@mail.gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kernel-team@android.com, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On 11/4/19 11:56 PM, Amir Goldstein wrote:
> On Mon, Nov 4, 2019 at 11:53 PM Mark Salyzyn <salyzyn@android.com> wrote:
>> Patch series:
>>
>> Mark Salyzyn (4):
>>    Add flags option to get xattr method paired to __vfs_getxattr
> Sigh.. did not get to fsdevel (again...) I already told you several times
> that you need to use a shorter CC list.

This is a direct result of the _required_ scripts/get_maintainer.pl 
logic, I am not going to override it for first send. I was going to 
forward to fsdevel after the messages settled, I am still waiting for 
1/4 to land on lore before continuing.

The first patch in the series needs to get in before the others. I was 
told to send the first one individually because the series has so many 
recipients and stakeholders, and <crickets> because no on could see the 
reason for the patch once it was all by itself. So I rejoined the set so 
they could see the reason for the first patch.

If only the first patch in the series that added the flag argument got 
in (somewhere), then the overlayfs portion would be much easier to handle.

>>    overlayfs: handle XATTR_NOSECURITY flag for get xattr method
>>    overlayfs: internal getxattr operations without sepolicy checking
>>    overlayfs: override_creds=off option bypass creator_cred
> It would be better for review IMO if you rebase your series on top of
> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git ovl-unpriv
Will do, send it only to fsdevel, other recipients? What do I do with 
get_maintainer.pl? The first patch in the series is noisy, I am getting 
more and more uncomfortable sending it to the list as it looks more and 
more like spam.
> 1. internal getxattr patch would be a one liner change to ovl_own_getxattr()
> 2. The documentation of override_creds would be much more
> meaningful if it used the overlay permission model terminology
> that Miklos added in his patch set and extend it
>
> Thanks,
> Amir.

-- Mark
