Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42732 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404669AbfFKXJn (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 11 Jun 2019 19:09:43 -0400
Reply-To: dwalsh@redhat.com
Subject: Re: [PATCH v2] overlay: allow config override of metacopy/redirect
 defaults
References: <20190607205105.21858-1-mcoffin13@gmail.com>
 <CAOQ4uximPqsNivkqD36LdNfT4g41v2rtDm+OB6t2z40dpWs_og@mail.gmail.com>
 <f5b0bddd-678b-bdd9-6fc7-cc9e5b3211e5@gmail.com>
 <CAOQ4uxjQQcrcpxhtu3kAJvGaK+xd5TfNB=7_UnNciGj990DN6Q@mail.gmail.com>
 <CAJfpegvy-Vfc6AEP7+=VfUtfL4izY8AzgoUdvqP4PHnLDEQhNg@mail.gmail.com>
 <20190610184043.GD25290@redhat.com> <20190610184553.GE25290@redhat.com>
 <CAJfpegvrOy3yBpu1AVBFyjdXBNM44k4gSqQ0F2npBG8wH8cUeg@mail.gmail.com>
 <20190611130932.GA28835@redhat.com>
 <cb363beb-9b2e-1d20-ca46-cba7724ec648@redhat.com>
 <20190611214951.GC28835@redhat.com>
 <be9bfd25-ff48-bd9e-25ff-aa2a5f5873ed@gmail.com>
From: Daniel Walsh <dwalsh@redhat.com>
Message-ID: <d6eabcef-0b8b-2c00-a39a-0283c9c674c1@redhat.com>
Date: Tue, 11 Jun 2019 19:09:25 -0400
MIME-Version: 1.0
In-Reply-To: <be9bfd25-ff48-bd9e-25ff-aa2a5f5873ed@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-unionfs-owner@vger.kernel.org
To: Matt Coffin <mcoffin13@gmail.com>, Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, Nalin Dahyabhai <nalin@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

On 6/11/19 5:57 PM, Matt Coffin wrote:
> This could just be because I don't understand the implications here, but
> wouldn't it be easier, at least for now, to just mount with
>
> redirect_dir=0,metacopy=0
We want the advantages of metacopy for use with User Namespace.
> in the mount parameters when building images, but allow the user's
> default settings to still take over when just executing a container?
>
> On 6/11/19 3:49 PM, Vivek Goyal wrote:
>> On Tue, Jun 11, 2019 at 05:44:33PM -0400, Daniel Walsh wrote:
>>> On 6/11/19 9:09 AM, Vivek Goyal wrote:
>>>> On Tue, Jun 11, 2019 at 02:37:34PM +0200, Miklos Szeredi wrote:
>>>>> On Mon, Jun 10, 2019 at 8:45 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>>>>> AFAICS what happens when generating a layer is to start with a clean
>>>>> upper layer, do some operations, then save the contents of the upper
>>>>> layer.  If redirect or metacopy is enabled, then the contents of the
>>>>> upper layer won't be portable.  So need to do something like this:
>>>>>
>>>>> traverse(overlay_dir, upper_dir, target_dir)
>>>>> {
>>>>>     iterate name for entries in $upper_dir {
>>>>>         if ($name is non-directory) {
>>>>>             copy($overlay_dir/$name, $target_dir/$name)
>>>>>         } else if ($name is redirect) {
>>>>>             copy-recursive($overlay_dir/$name, $target_dir/$name)
>>>>>         } else {
>>>>>             copy($overlay_dir/$name, $target_dir/$name)
>>>>>             traverse($overlay_dir/$name, $upper_dir/$name, $target_dir/$name)
>>>>>         }
>>>>>     }
>>>>> }
>>>>>
>>>>> Basically: traverse the *upper layer* but copy files and directories
>>>>> from the *overlay*.  Does that make sense?
